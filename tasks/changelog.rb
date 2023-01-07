# frozen_string_literal: true

if RUBY_VERSION < "2.6"
  puts "Changelog utilities available only for Ruby 2.6+"
  exit(1)
end

# Changelog utility
class Changelog
  ENTRIES_PATH = "changelog/"
  FIRST_HEADER = /#{Regexp.escape("## Master (Unreleased)\n")}/m.freeze
  CONTRIBUTORS_HEADER = /#{Regexp.escape("<!-- Contributors -->\n\n")}/m.freeze
  ENTRIES_PATH_TEMPLATE = "#{ENTRIES_PATH}%<type>s_%<name>s.md"
  TYPE_REGEXP = /#{Regexp.escape(ENTRIES_PATH)}([a-z]+)_/.freeze
  TYPE_TO_HEADER = { new: "New features", fix: "Bug fixes", change: "Changes" }.freeze
  HEADER = /### (.*)/.freeze
  PATH = "CHANGELOG.md"
  REF_URL = "https://github.com/rubocop/rubocop-committee"
  MAX_LENGTH = 40
  CONTRIBUTOR = "[@%<link>s]: https://github.com/%<user>s"
  SIGNATURE = Regexp.new(format(Regexp.escape("[@%<user>s]"), user: '([\w-]+)'))
  CONTRIBUTOR_REGEXP = %r{(\[@\w*\]: https://github\.com/\w*)}.freeze
  EOF = "\n"

  # New entry
  Entry = Struct.new(:type, :body, :ref_type, :ref_id, :user, keyword_init: true) do
    def initialize(type:, body: last_commit_title, ref_type: nil, ref_id: nil, user: github_user)
      id, body = extract_id(body)
      ref_id ||= id || "x"
      ref_type ||= id ? :issues : :pull
      super
    end

    def write
      FileUtils.mkdir_p(ENTRIES_PATH)
      File.write(path, content)
      path
    end

    def path
      format(ENTRIES_PATH_TEMPLATE, type: type, name: str_to_filename(body))
    end

    def content
      period = "." unless body.end_with? "."
      "- #{ref}: #{body}#{period} ([@#{user}])\n"
    end

    def ref
      "[##{ref_id}](#{REF_URL}/#{ref_type}/#{ref_id})"
    end

    def last_commit_title
      `git log -1 --pretty=%B`.lines.first.chomp
    end

    def extract_id(body)
      /^\[Fix(?:es)? #(\d+)\] (.*)/.match(body)&.captures || [nil, body]
    end

    def str_to_filename(str)
      str
        .split
        .reject(&:empty?)
        .map { |s| prettify(s) }
        .inject do |result, word|
          s = "#{result}_#{word}"
          return result if s.length > MAX_LENGTH

          s
        end
    end

    def github_user
      user = `git config --global credential.username`.chomp
      warn 'Set your username with `git config --global credential.username "myusernamehere"`' if user.empty?

      user
    end

    private

    def prettify(str)
      str.gsub!(/\W/, "_")

      # Separate word boundaries by `_`.
      str.gsub!(/([A-Z]+)(?=[A-Z][a-z])|([a-z\d])(?=[A-Z])/) do
        (Regexp.last_match(1) || Regexp.last_match(2)) << "_"
      end

      str.gsub!(/\A_+|_+\z/, "")
      str.downcase!
      str
    end
  end

  def self.pending?
    entry_paths.any?
  end

  def self.entry_paths
    Dir["#{ENTRIES_PATH}*"]
  end

  def self.read_entries
    entry_paths.to_h { |path| [path, File.read(path)] }
  end

  attr_reader :header, :rest

  def initialize(content: File.read(PATH), entries: Changelog.read_entries)
    require "strscan"

    parse(content)
    @entries = entries
  end

  def and_delete!
    @entries.each_key { |path| File.delete(path) }
  end

  def merge!
    File.write(PATH, merge_content)
    self
  end

  def unreleased_content
    entry_map = parse_entries(@entries)
    merged_map = merge_entries(entry_map)
    merged_map.flat_map { |header, things| ["### #{header}\n", *things, ""] }.join("\n")
  end

  def merge_content
    merged_content = [@header, unreleased_content, @changes.chomp, *all_contributors].join("\n")

    merged_content << EOF
  end

  def all_contributors
    (@contributors.scan(CONTRIBUTOR_REGEXP).flatten + new_contributors).uniq.sort
  end

  def new_contributors
    contributors
      .map { |user| format(CONTRIBUTOR, link: user.downcase, user: user) }
  end

  def contributors
    contributors = @entries.values.flat_map do |entry|
      entry.match(/\. \((?<contributors>.+)\)\n/)[:contributors].split(",")
    end

    contributors.join.scan(SIGNATURE).flatten
  end

  private

  def merge_entries(entry_map)
    all = @unreleased.merge(entry_map) { |_k, v1, v2| v1.concat(v2) }
    canonical = TYPE_TO_HEADER.values.to_h { |v| [v, nil] }
    canonical.merge(all).compact
  end

  def parse(content)
    ss = StringScanner.new(content)
    @header = ss.scan_until(FIRST_HEADER)
    @unreleased = parse_release(ss.scan_until(/\n(?=## )/m))
    @changes = ss.scan_until(CONTRIBUTORS_HEADER)
    @contributors = ss.rest
  end

  # @return [Hash<type, Array<String>]]
  def parse_release(unreleased)
    unreleased
      .lines
      .map(&:chomp)
      .reject(&:empty?)
      .slice_before(HEADER)
      .to_h do |header, *entries|
        [HEADER.match(header)[1], entries]
      end
  end

  def parse_entries(path_content_map)
    changes = Hash.new { |h, k| h[k] = [] }
    path_content_map.each do |path, content|
      header = TYPE_TO_HEADER.fetch(TYPE_REGEXP.match(path)[1].to_sym)
      changes[header].concat(content.lines.map(&:chomp))
    end
    changes
  end
end
