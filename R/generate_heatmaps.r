#' generate_heatmaps
#' 
#' Generate two heatmaps: one static and one interactive
#' 
#' @param input_dir ...
#' @param counts_file_name ...
#' @param output_dir ...
#' @param downsample_label ...
#' @export
#' @author Yuanyuan Wang
#' 

generate_heatmaps <- function(
  input_dir,
  counts_file_name,
  output_dir,
  downsample_label) {
  
  # generate paths and file names
  # note: paths need to have a "/" at the end
  
  counts_file <- paste0(input_dir,counts_file_name)
  counts_file
  processing_date <- Sys.Date()
  static_heatmap_file <- paste0(output_dir,
                                'Static-Heatmap-',
                                processing_date,
                                '-',
                                downsample_label,
                                '.pdf')
  
  interactive_heatmap_file <- paste0(output_dir,
                                     'Interactive-Heatmap-',
                                     processing_date,
                                     '-',
                                     downsample_label,
                                     '.html')
  
  # read input data
  
  dat <- read.table(counts_file, header = TRUE)
  amp_ID <- dat[,'ID']
  dat <- dat[,-1]
  rownames(dat) <- amp_ID
  sample_ID <- colnames(dat)
  dat <- dat %>%
    mutate_if(is.numeric, list(~replace_na(., 0)))


  
  # 1. static heatmap
  ## a. covert data to long data ###
  
  colnames(dat) <- sample_ID
  break_points <- c(-Inf, 10, 30, 50, 100, Inf)
  break_labels <- c(1,2,3,4,5)
  wide_dat <- t(dat) # transpose data: sample by amplicon
  long_dat <- wide_dat %>% 
    as.data.frame() %>%
    tibble::rownames_to_column(var = "sample") %>% 
    pivot_longer(-sample, names_to = "amplicon", values_to = "coverage") %>%
    as.data.frame() 
  long_dat$coverage_category <- cut(long_dat$coverage, breaks = break_points, labels = break_labels)
  
  ## b. cluster data by samples ###
  
  dat.scaled <- as.matrix(scale(t(dat)))
  dat.dendro <- as.dendrogram(hclust(d = dist(x = dat.scaled)))
  dendro.plot <- ggdendrogram(data = dat.dendro, rotate = TRUE)
  
  tip.order <- order.dendrogram(dat.dendro) # this will change the order of samples on the plot
  long_dat$sample <- factor(x = long_dat$sample,
                            levels = rownames(dat.scaled)[tip.order], ordered =TRUE)
  ## c. plot ###
  
  long_dat %>%
    ggplot(
      mapping = 
        aes(x = amplicon, 
            y = sample, 
            fill = coverage_category)) + 
    geom_tile() +
    scale_fill_brewer(
      palette = 'YlOrBr',
      name = 'average\ncoverage',
      labels = c('less than 10',
                 '10 to 30', 
                 '30 to 50',
                 '50 to 100',
                 'more than 100')) +
    theme(
      text = element_text(size = 4),
      axis.text.x = element_text(angle = 90, size = 2), # rotate the angle of amplicon names and shrink the font size
      legend.position = 'top') +
    ggtitle(paste0("Coverage Heatmap ",downsample_label))
  
  ggsave(static_heatmap_file) ## save to your output directory
  
  # 2. Interactive heatmap
  cat.dat <- dat
  for (i in 1:ncol(dat)){
    cat.dat[,i] <- as.numeric(cut(dat[,i], breaks = break_points, labels = break_labels))
  }
  
  heatmaply(t(cat.dat), 
            column_text_angle = 90, 
            # margins = c(40, 130),
            xlab = 'amplicons',
            ylab = 'samples',
            Colv = FALSE,
            show_dendrogram = FALSE,
            fontsize_col = 2,
            fontsize_row = 7,
            colors = YlOrBr,
            file=interactive_heatmap_file) # files will be saved automatically
  
}








