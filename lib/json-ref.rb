require 'json'
require 'hana'

class JSONRef
  def initialize(document, **options)
    @document = document
    @refs = []
    @patches = []
    @options = options
  end

  def expand
    @document = load_ref_file(read_ref_file(@document)) if @document.is_a?(String)

    find_refs(@document).each do |path|
      ref = Hana::Pointer.eval(path, @document)

      value = ref_value(ref['$ref'])

      if ref_uri?(ref['$ref'])
        value = expand_ref_value(ref['$ref'], value)
      end

      @patches << { 'op' => 'replace', 'path' => path, 'value' => value }
    end

    Hana::Patch.new(@patches).apply(@document)
  end

  def self.expand(document)
    self.new(document).expand
  end

  private

  def expand_ref_value(ref_path, value)
    if @options[:base_path]&.starts_with?('http') || @options[:base_path]&.starts_with?('https')
      uri = URI.join(@options[:base_path], ref_path)
      base_path = uri.to_s.split('/')[0..-2].join('/') + '/'
    else
      base_path = File.join(@options[:base_path], ref_path).split('/')[0..-2].join('/') + '/'
    end

    if value.is_a?(Array)
      value.map { |local_value| JSONRef.new(local_value, @options.merge(base_path: base_path)).expand }
    else
      JSONRef.new(value, @options.merge(base_path: base_path)).expand
    end
  end

  def ref_uri?(ref_path)
    ref_path =~ /\.#{input_file_extension}$/
  end

  def ref_value(ref_path)
    if ref_path[0] == '#'
      Hana::Pointer.new(ref_path[1..-1]).eval(@document)
    else
      load_ref_file(read_ref_file(ref_path))
    end
  end

  def input_file_extension
    input_format == :json ? 'json' : 'yaml'
  end

  def read_ref_file(ref_file_path)
    return File.read(ref_file_path) unless @options[:base_path]

    if @options[:base_path].starts_with?('http') || @options[:base_path].starts_with?('https')
      uri = URI.join(@options[:base_path], ref_file_path)
      open(uri)
    else
      File.read(File.join(@options[:base_path], ref_file_path))
    end
  end

  def load_ref_file(ref_file)
    if input_format == :json
      JSON.load(ref_file)
    else
      YAML.load(ref_file)
    end
  end

  def input_format
    @options[:input_format] ||= :json
  end

  def find_refs(doc, path = [])
    if doc.has_key?('$ref')
      @refs << path
    else
      doc.each do |key, value|
        value.each_with_index do |item, index|
          find_refs(item, path + [key, index.to_s]) if item.is_a?(Hash)
        end if value.is_a?(Array)

        find_refs(value, path + [key]) if value.is_a?(Hash)
      end
    end

    @refs
  end
end
