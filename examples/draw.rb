require 'yaml'
require 'lindy'

rules = YAML.load_file(ARGV.first)
canvas = Lindy.run(rules)

canvas.to_png.save("lindy.png")
