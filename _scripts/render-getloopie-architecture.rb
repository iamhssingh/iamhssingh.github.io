# Rebuild with ruby _scripts/render-getloopie-architecture.rb (requires Graphviz).
require 'json'
require 'open3'
require 'yaml'

root = File.expand_path('..', __dir__)
lanes = YAML.safe_load_file(File.join(root, '_data/getloopie_architecture.yml')).fetch('lanes')

dot = <<~DOT
  digraph GetLoopie {
    graph [bgcolor="transparent", fontname="Helvetica", nodesep=.26, ranksep=.31, pad=.12, newrank=true];
    node [shape=box, style="rounded,filled", color="#8b8278", fillcolor="#fdfcf9", fontcolor="#20201e", fontname="Helvetica", fontsize=12, margin=".15,.10"];
    edge [color="#766d64", arrowsize=.6];
DOT

lanes.each_with_index do |lane, index|
  lane_id = lane.fetch('id')
  steps = lane.fetch('steps')
  input = index.zero? ? "Captured demo Slack events\nReplay through ingestion" : "Golden questions and expected threads\nRun with user and thread context"

  dot << <<~DOT
    subgraph cluster_#{lane_id} {
      label=#{JSON.generate(lane.fetch('title'))};
      labelloc=t; labeljust=l; color="#ded9d1"; fontcolor="#20201e"; margin=14;
      #{lane_id}_gold [label=#{JSON.generate(input)}, fillcolor="#f5eee9", color="#8d3229"];
      #{lane_id}_gold -> #{steps.first.fetch('id')} [style=dashed, color="#8d3229"];
  DOT

  if lane['live_input']
    dot << "  #{lane_id}_live [label=#{JSON.generate(lane.fetch('live_input'))}];\n"
    dot << "  {rank=same; #{lane_id}_live; #{lane_id}_gold;}\n"
    dot << "  #{lane_id}_live -> #{steps.first.fetch('id')};\n"
  end

  steps.each_with_index do |step, position|
    id = step.fetch('id')
    dot << "  #{id} [label=#{JSON.generate(step.fetch('diagram'))}];\n"
    dot << "  #{steps[position - 1].fetch('id')} -> #{id};\n" unless position.zero?
    next unless step['checkpoint']

    label = "#{step.fetch('checkpoint')}\n#{step.fetch('diagram_failure')}"
    dot << "  #{id}_eval [label=#{JSON.generate(label)}, fillcolor=\"#f5eee9\", color=\"#8d3229\"];\n"
    dot << "  {rank=same; #{id}; #{id}_eval;}\n"
    dot << "  #{id} -> #{id}_eval [style=dashed, color=\"#8d3229\"];\n"
  end
  dot << "}\n"
end
dot << "evidence -> retrieval [constraint=false];\n"
dot << "evidence -> query_gold [style=invis, weight=6];\n"
dot << "}\n"

svg, errors, status = Open3.capture3('dot', '-Tsvg', stdin_data: dot)
abort errors unless status.success?
File.write(File.join(root, 'assets/diagrams/getloopie-architecture.svg'), svg)
