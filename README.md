# Make heatmaps

```
install.packages('devtools')
library(devtools)
devtools::install_github('YYW-UMN/ggcovid')
library(ggcovid)

generate_heatmaps(
  input_dir = '/path/to/where/the/count/data/is/located/',
  counts_file_name = 'counts.txt',
  output_dir ='/path/to/output/results/',
  downsample_label = '100k'
)

Please trim amplicon and sample names in advance if they are too long for visualization.
The plot function does not edit names.

The output files will look like:
Static-Heatmap-2020-12-17-downsample-label.pdf
Interactive-Heatmap-2020-12-17-downsample-label.html
