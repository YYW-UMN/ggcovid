## Make heatmaps from count files

## Input txt file format:

|          | sample_1 | sample_2 | sample_3 |
|----------|----------|----------|----------|
|amplicon_1| 621.26	  |480.42	   |491.14	  |
|amplicon_2| 141.21	  |94.19	   |280.56	  |
|amplicon_3| 21.56    |80.90	   |591.97	  |

Please trim amplicon and sample names in advance if they are too long for visualization.
The plot function does not edit names.

## Install:
```
library(devtools)
devtools::install_github('YYW-UMN/ggcovid')
library(ggcovid)
```

## Generate heatmaps:
```
generate_heatmaps(
  input_dir = '/path/to/where/the/count/data/is/located/',
  counts_file_name = 'counts.txt',
  output_dir ='/path/to/output/results/',
  downsample_label = '100k'
)
```

## Output files:
The output files will look like:

Naming format: Static-Heatmap-2020-12-17-downsample-label.pdf
<p float="left">
<img src="https://github.com/YYW-UMN/ggcovid/blob/main/heatmaps/Static_Heatmap_Example.jpeg" width="700" />
</p>

Interactive-Heatmap-2020-12-17-downsample-label.html
