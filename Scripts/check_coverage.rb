#!/usr/bin/env ruby

require 'json'

coverage_path = ARGV.fetch(0)
threshold = Float(ARGV.fetch(1, '90'))
report = JSON.parse(File.read(coverage_path))
files = []

if report['data']
  report['data'].each do |data|
    data.fetch('files', []).each do |file|
      lines = file.dig('summary', 'lines') || {}
      files << [file['filename'], lines['count'].to_i, lines['covered'].to_i]
    end
  end
elsif report['targets']
  report['targets'].each do |target|
    target.fetch('files', []).each do |file|
      count = file['executableLines'].to_i
      covered = if file.key?('coveredLines')
                  file['coveredLines'].to_i
                else
                  (file['lineCoverage'].to_f * count).round
                end
      files << [file['path'] || file['name'], count, covered]
    end
  end
else
  warn '无法识别覆盖率报告格式'
  exit 2
end

source_files = files.select do |path, count, _covered|
  path && count.positive? && path.match?(%r{/AxcUIKit/(Classes|Umbrella)/})
end

if source_files.empty?
  warn '覆盖率报告中没有找到 AxcUIKit 源文件'
  exit 2
end

line_count = source_files.sum { |_path, count, _covered| count }
covered_count = source_files.sum { |_path, _count, covered| covered }
coverage = covered_count * 100.0 / line_count

puts format('AxcUIKit 行覆盖率：%.2f%%（%d/%d）', coverage, covered_count, line_count)
exit 0 if coverage >= threshold

warn format('覆盖率 %.2f%% 低于门禁 %.2f%%', coverage, threshold)
exit 1
