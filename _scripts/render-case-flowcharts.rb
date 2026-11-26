# Rebuild with ruby _scripts/render-case-flowcharts.rb (requires Graphviz).
require 'fileutils'
require 'json'
require 'open3'
require 'yaml'

def wrap_label(text, width = 33)
  text.split.each_with_object(['']) do |word, lines|
    if lines.last.empty?
      lines[-1] = word
    elsif lines.last.length + word.length + 1 <= width
      lines[-1] = "#{lines.last} #{word}"
    else
      lines << word
    end
  end.join("\n")
end

root = File.expand_path('..', __dir__)
studies = YAML.safe_load_file(File.join(root, '_data/portfolio.yml')).fetch('work')
outdir = File.join(root, 'assets/diagrams')
FileUtils.mkdir_p(outdir)

studies.each do |study|
  design = study['design']
  next unless design

  dot = <<~DOT
    digraph CaseFlow {
      graph [bgcolor="transparent", fontname="Helvetica", nodesep=.26, ranksep=.28, pad=.12, newrank=true];
      node [shape=box, style="rounded,filled", color="#8b8278", fillcolor="#fdfcf9", fontcolor="#20201e", fontname="Helvetica", fontsize=12, margin=".14,.09"];
      edge [color="#766d64", arrowsize=.6];
  DOT

  %w[before after].each do |phase|
    caption = "#{phase.capitalize}\n#{wrap_label(design.fetch("#{phase}_caption"))}"
    dot << <<~DOT
      subgraph cluster_#{phase} {
        label=#{JSON.generate(caption)};
        labelloc=t; labeljust=l; color="#ded9d1"; fontcolor="#20201e"; margin=12;
    DOT
    fill = phase == 'after' ? '#f5eee9' : '#fdfcf9'
    design.fetch(phase).each_with_index do |stage, index|
      dot << "  #{phase}_#{index} [label=#{JSON.generate(wrap_label(stage))}, fillcolor=\"#{fill}\"];\n"
      dot << "  #{phase}_#{index - 1} -> #{phase}_#{index};\n" unless index.zero?
    end
    dot << "}\n"
  end

  [design.fetch('before').size, design.fetch('after').size].min.times do |rank|
    dot << "  {rank=same; before_#{rank}; after_#{rank};}\n"
    dot << "  before_#{rank} -> after_#{rank} [style=invis, weight=6];\n"
  end
  dot << "}\n"

  svg, errors, status = Open3.capture3('dot', '-Tsvg', stdin_data: dot)
  abort "#{study.fetch('id')}: #{errors}" unless status.success?
  File.write(File.join(outdir, "case-#{study.fetch('id')}.svg"), svg)
end
