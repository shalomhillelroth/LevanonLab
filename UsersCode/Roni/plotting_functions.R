library(ggplot2)

#function for easy and quick plotting for our needs
#colors vector should be in ABC order of categories, order is the wanted categories order
boxPlot <- function(table, xcol, ycol, fillcol=xcol, title, subtitle=NULL, xlab=NULL, ylab=NULL, filllab=NULL, colors = NULL, show_points = TRUE, show_outlier = FALSE, expand_lims = TRUE, dodge_points = FALSE, color_points=FALSE) {
  g=ggplot(data = table , aes(y=ycol, x=xcol, fill=fillcol)) +
    #geom_boxplot(aes(fill=fillcol), outlier.shape = NA)+
    ylab(ylab) +
    # stat_compare_means(comparisons = comparisons_todo , method = "t.test", p.adjust.methods = "bonferroni", label = "p.signif", hide.ns = T)+
    ggtitle(title) + 
    theme_light() +
    theme(plot.title = element_text(hjust = 0.5, face = "bold", vjust = -0.5),
          plot.subtitle = element_text(hjust = 0.5, vjust = -0.5),
          axis.ticks = element_line(colour="black"),
          legend.position = "none")
  if(show_outlier) { g = g + geom_boxplot(aes(fill=fillcol), outlier.size = 0.5)} else { g = g + geom_boxplot(aes(fill=fillcol), outlier.shape = NA)}
  if(show_points & !dodge_points & !color_points) { g = g + geom_jitter(position = position_jitter(width = .15, height = 0), size = 1 ,colour = "black") }
  if(show_points & !dodge_points & color_points) { g = g + geom_jitter(aes(fill=fillcol), position = position_jitter(width = .15, height = 0), size = 1, shape = 21) }
  if(show_points & dodge_points & !color_points) { g = g + geom_jitter(position = position_jitterdodge(jitter.width = .1), size = 1 ,colour = "black") }
  if(show_points & dodge_points & color_points) { g = g + geom_jitter(aes(fill=fillcol), position = position_jitterdodge(jitter.width = .1), size = 1, shape = 21) }
  if(expand_lims) { g = g + expand_limits(y = 0) }
  if(!is.null(subtitle)) { g = g + labs(subtitle = subtitle) }
  if(!is.null(colors)) { g = g + scale_fill_manual(values = colors) }
  if(!is.null(xlab)) { g = g + xlab(xlab) }
  if(!is.null(ylab)) { g = g + ylab(ylab) }
  if(!is.null(filllab)) { g = g + labs(fill = filllab) }
  
  return(g)
}


#function for easy and quick plotting for our needs
#colors vector should be in ABC order of categories, order is the wanted categories order
violinPlot <- function(table, xcol, ycol, fillcol=xcol, title, subtitle=NULL, xlab=NULL, ylab=NULL, filllab=NULL, colors = NULL, show_points = TRUE, show_outlier = FALSE, expand_lims = TRUE, dodge_points = FALSE, draw_quantiles = c(0.5)) {
  g=ggplot(data = table , aes(y=ycol, x=xcol, fill=fillcol)) +
    geom_violin(aes(fill=fillcol), draw_quantiles = draw_quantiles) + 
    ylab(ylab) +
    # stat_compare_means(comparisons = comparisons_todo , method = "t.test", p.adjust.methods = "bonferroni", label = "p.signif", hide.ns = T)+
    ggtitle(title) + 
    theme_light() +
    theme(plot.title = element_text(hjust = 0.5, face = "bold", vjust = -0.5),
          plot.subtitle = element_text(hjust = 0.5, vjust = -0.5),
          axis.ticks = element_line(colour="black"),
          legend.position = "none")
  if(show_points & !dodge_points) { g = g + geom_jitter(position = position_jitter(width = .15, height = 0), size = 1 ,colour = "black") }
  if(show_points & dodge_points) { g = g + geom_jitter(position = position_jitterdodge(jitter.width = .1), size = 1 ,colour = "black") }
  if(expand_lims) { g = g + expand_limits(y = 0) }
  if(!is.null(subtitle)) { g = g + labs(subtitle = subtitle) }
  if(!is.null(colors)) { g = g + scale_fill_manual(values = colors) }
  if(!is.null(xlab)) { g = g + xlab(xlab) }
  if(!is.null(ylab)) { g = g + ylab(ylab) }
  if(!is.null(filllab)) { g = g + labs(fill = filllab) }
  
  return(g)
}


#colors vector should be the colors by ABC order of Type categories
scatterPlot <- function(table, xcol, ycol, fillcol, xlab=NULL, ylab=NULL, colorlab=NULL, title, subtitle=NULL, colors=NULL, point_size=1) {
  g=ggplot(table, aes(x = xcol, y = ycol, color = fillcol)) + 
    geom_point(size = point_size) + 
    ggtitle(title) +
    expand_limits(y = 0, x = 0) +
    #stat_summary(fun.data=mean_cl_normal) + 
    #geom_smooth(method='lm',formula=y~x, se = F, linetype = "dotted") +
    theme_light() + 
    theme(axis.text.x=element_text(size = 12),
          plot.title = element_text(hjust = 0.5, face = "bold", vjust = -0.5),
          plot.subtitle = element_text(hjust = 0.5, vjust = -0.5),
          axis.ticks = element_line(colour="black"),
          legend.position = "bottom")
  if(!is.null(subtitle)) { g = g + labs(subtitle = subtitle) }
  if(!is.null(colors)) { g = g + scale_color_manual(values = colors) }
  if(!is.null(xlab)) { g = g + xlab(xlab) }
  if(!is.null(ylab)) { g = g + ylab(ylab) }
  if(!is.null(colorlab)) { g = g + labs(color = colorlab) }
  return(g)
}

#colors vector should be the colors by ABC order of Type categories
scatterPlotLabeled <- function(table, xcol, ycol, fillcol, xlabel, ylabel, title) {
  g=ggplot(table, aes(x = xcol, y = ycol, color = fillcol, label = Sample)) +
    geom_point() +
    geom_text(aes(label=Sample),hjust=0.5, vjust=-1, size = 1.9, angle = 10) +
    scale_colour_manual(values = colors) +  #CHANGE
    ylab(ylabel) +
    xlab(xlabel) +
    ggtitle(title) +
    theme_light() + 
    theme(axis.text.x=element_text(size = 12),
          plot.title = element_text(hjust = 0.5),
          axis.ticks = element_line(colour="black"),
          legend.position = "bottom")
  return(g)
}

histPlot <- function(table, varcol, bin_width, title="Histogram", xlabel=NULL, ylabel = "counts", color="hotpink4", subtitle = paste0("Bin width: ", bin_width)) {
  g=ggplot(data = table , aes(x = varcol)) +
    geom_histogram(fill = color, binwidth = bin_width) + #bins = num_bins) +
    # expand_limits(y = 0) +
    ggtitle(title, subtitle = subtitle) +
    theme_light() +
    theme(axis.text.x=element_text(angle = 30, hjust = 1, size = 12),
          # panel.background = element_rect(fill='white', colour='black'),
          # legend.text =element_text( "",size=7),
          # legend.justification=c(1,1),
          # panel.grid.major = element_blank(),
          # panel.grid.minor = element_blank(),
          plot.title = element_text(hjust = 0.5, face = "bold", vjust = -0.5),
          plot.subtitle = element_text(hjust = 0.5, vjust = -0.5),
          axis.ticks = element_line(colour="black"),
          legend.position = "bottom")
  
  if(!is.null(xlabel)) { g = g + xlab(xlabel) }
  if(!is.null(ylabel)) { g = g + ylab(ylabel) }
  
  return(g)
}

freqPlot <- function(table, title, varcol, bin_width, xlabel=NULL, ylabel = "counts", color="hotpink4", subtitle = paste0("Bin width: ", bin_width)) {
  g=ggplot(data = table , aes(x = varcol)) +
    geom_freqpoly(color = color, binwidth = bin_width) +
    ylab(ylabel) +
    # expand_limits(y = 0) +
    ggtitle(title, subtitle = subtitle) +
    theme_light() +
    theme(axis.text.x=element_text(angle = 30, hjust = 1, size = 12),
          # panel.background = element_rect(fill='white', colour='black'),
          # legend.text =element_text( "",size=7),
          # legend.justification=c(1,1),
          # panel.grid.major = element_blank(),
          # panel.grid.minor = element_blank(),
          plot.title = element_text(hjust = 0.5, face = "bold", vjust = -0.5),
          plot.subtitle = element_text(hjust = 0.5, vjust = -0.5),
          axis.ticks = element_line(colour="black"),
          legend.position = "none")
  
  if(!is.null(xlabel)) { g = g + xlab(xlabel) }
  
  return(g)
}


#returns the stat with the higher R
calcStats <- function(x_data, y_data) {
  head(x_data, n = 3)
  head(y_data, n = 3)
  
  sp = cor.test(x = x_data, y = y_data, method = "spearman")
  pe = cor.test(x = x_data, y = y_data, method = "pearson")
  
  return(list(pe, sp))
}

stats_output_format <- function(stats_output_dir, res, test, correction_method=NULL, suffix = "") {
  if(!is.null(correction_method)) {
    res <- res %>% group_by(Variable) %>% mutate(PValueAdjusted = p.adjust(PValue, method = correction_method))
    write.csv(res, file = file.path(stats_output_dir, 
                                    paste0(gsub(gsub(x = deparse(test)[2], pattern = "UseMethod|[()\"\\]", replacement = ""), pattern = ".", fixed = T, replacement = "_"),
                                           "_", correction_method, suffix, ".csv")), quote = F, row.names = F)
  } else {
    write.csv(res, file = file.path(stats_output_dir, 
                                    paste0(gsub(gsub(x = deparse(test)[2], pattern = "UseMethod|[()\"\\]", replacement = ""), pattern = ".", fixed = T, replacement = "_"),
                                           suffix, ".csv")), quote = F, row.names = F)
  }
}

#function for easier plotting
plotCorr <- function(data, xcol, ycol, colorcol, xlabel, ylabel, title, colors = NULL, stats=NULL) {
  print(xlabel)
  print(ylabel)
  if(is.null(stats)) {stats = calcStats(x_data = xcol, y_data = ycol)}
  pe <- stats[[1]]
  sp <- stats[[2]]
  stat_line <- paste0(paste0(strsplit(x = pe$method, split = " ")[[1]][1], " R = " , round(pe$estimate,digits = 3), ", p.value = " , format(pe$p.value,scientific = TRUE)),
                      "\n",
                      paste0(strsplit(x = sp$method, split = " ")[[1]][1], " R = " , round(sp$estimate,digits = 3), ", p.value = " , format(sp$p.value,scientific = TRUE)))
  print(stat_line)
  
  g=ggplot(data, aes(x = xcol, y = ycol)) +
    geom_smooth(method = "lm",color="black", fill="gray80")  +
    geom_point(size=1, aes(color = colorcol)) +
    xlab(xlabel) + ylab(ylabel) +
    theme_classic() + 
    expand_limits(y = 0) +
    labs(title = title, subtitle = stat_line, color="Group") + # Add notations
    theme(plot.title = element_text(hjust = 0.5, size = 14, face = "bold"), 
          plot.subtitle = element_text(hjust = 0.5, size = 12, lineheight = 1.5))
  
  if(!is.null(colors)) { g = g + scale_color_manual(values = colors) }
  #annotate("text", x = min(xcol)+moveX, y = max(max(ycol), possible_max)-moveY, label = paste0(statName, "'s R =" , round(stat$r[2],digits = 3)),size=4,hjust=0) +
  #annotate("text", x = min(xcol)+moveX, y = max(max(ycol), possible_max)-(diffY+moveY), label = paste0(statName, " pVal = " , format(stat$P[2],scientific = TRUE)), size=4,hjust=0)
  return(g)
}


#' Conducts a statistical test on two groups of values.
#' 
#' @description
#' `two_groups_stats_conductor` uses the `Classification` column to test two groups with given tests for given variables.
#'
#' @details
#' This is a function for easier statistical testing over a list of variable columns and statistical tests.
#' The output is written to files at given directory
#' 
#' @param stats_data table of data to test, columns include variable values and rows include samples. Classification column with groups must be given
#' @param combinations list of pairs of group combinations to test
#' @param var_columns vector of variables to test
#' @param statistical_tests vector of statistical testing functions to use
#' @param correction_method p-value correction method as used by p.adjust
#' @param stats_output_dir output directory
two_groups_stats_conductor = function(stats_data, combinations, var_columns, class_col, statistical_tests, 
                                      correction_method=NULL, stats_output_dir=NULL, suffix = "", verbose = FALSE) {
  # make into data fame type to allow base operations
  stats_data = as.data.frame(stats_data)
  # iterate over tests
  for (test in statistical_tests) {
    if (verbose) {print(test)} # notify on verbos
    # iterate over variables
    res = data.frame()
    for (variable in var_columns) {
      if (verbose) {print(variable)} # notify on verbose
      #pass if variable does not exist
      if (!variable %in% colnames(stats_data)) 
        next
      # iterate over comparisons
      for (pair in combinations) {
        if (verbose) {print(pair)} # notify on verbos
        # get indexes
        a_indexes = stats_data[class_col == pair[1],variable]
        b_indexes = stats_data[class_col == pair[2],variable]

        if (verbose) {print(a_indexes); print(b_indexes)} # notify on verbos
        # if observation number allows - calculate p-value
        if (length(na.omit(a_indexes)) > 2 & length(na.omit(b_indexes)) > 2) 
          pval = test(a_indexes, b_indexes)$p.value
        else 
          pval = NA
        # std_a = sd(a_indexes)
        # std_b = sd(b_indexes)
        
        # bind to previous results
        res = rbind(res, as.data.frame(list(TestedValueA = pair[1],
                                            TestedValueB = pair[2],
                                            Variable = variable,
                                            # MeanIndexA = mean_a,
                                            # MeanIndexB = mean_b,
                                            # StdIndexA = std_a,
                                            # StdIndexB = std_b,
                                            PValue = pval)))
      }
    }
    if (is.null(stats_output_dir) & is.null(correction_method))
      return(res) 
    if (is.null(stats_output_dir)) {
      res <- res %>% group_by(Variable) %>% mutate(PValueAdjusted = p.adjust(PValue, method = correction_method))
      return(res)
    }
    stats_output_format(stats_output_dir = stats_output_dir, res = res, test = test, correction_method = correction_method, suffix = suffix)
  }
}

#' Conducts a paired statistical test on two groups of values.
two_groups_paired_stats_conductor = function(stats_data, combinations, var_columns, pair_col, class_col,
                                             statistical_tests, stats_output_dir=NULL, correction_method = NULL, 
                                             suffix = "", verbose = FALSE) {
  # make into data fame type to allow base operations
  stats_data = as.data.frame(stats_data)
  for (test in statistical_tests) {
    if (verbose) {print(test)} # notify on verbos
    # initialize data frame
    res = data.frame()
    for (variable in var_columns) {
      if (verbose) {print(variable)} # notify on verbose
      #pass if variable does not exist
      if (!variable %in% colnames(stats_data)) 
        next
      for (pair in combinations) {
        if (verbose) {print(pair)} # notify on verbos
        # get indexes
        a_indexes = stats_data[class_col == pair[1],c(variable, pair_col)]
        b_indexes = stats_data[class_col == pair[2],c(variable, pair_col)]
        # sort by repeat
        a_indexes = a_indexes[order(a_indexes[,pair_col]),variable]
        b_indexes = b_indexes[order(b_indexes[,pair_col]),variable]
        # mean_a = mean(a_indexes)
        # mean_b = mean(b_indexes)
        # assert length
        if (length(a_indexes)!=length(b_indexes))
          stop("Groups have different number of values")
        else if (length(na.omit(a_indexes)) > 3 & length(na.omit(b_indexes)) > 3) 
          pval = test(a_indexes, b_indexes, paired = T)$p.value
        else 
          pval = NA
        # std_a = sd(a_indexes)
        # std_b = sd(b_indexes)
        
        res = rbind(res, as.data.frame(list(TestedValueA = pair[1],
                                            TestedValueB = pair[2],
                                            Variable = variable,
                                            # MeanIndexA = mean_a,
                                            # MeanIndexB = mean_b,
                                            # StdIndexA = std_a,
                                            # StdIndexB = std_b,
                                            PValue = signif(pval, digits = 4))))
      }
    }
    
    if (is.null(stats_output_dir) & is.null(correction_method))
      return(res) 
    if (is.null(stats_output_dir))
      return(res %>% group_by(Variable) %>% mutate(PValueAdjusted = p.adjust(PValue, method = correction_method))) 
    stats_output_format(stats_output_dir = stats_output_dir, res = res, test = test, correction_method = correction_method, suffix = suffix)
  }
}
### conducts a statistical test on one group of values
normality_stats_conductor = function(stats_data, var_columns, class_col,
                                     statistical_test = shapiro.test, test_name = "shapiro.test",
                                     correction_method=NULL, stats_output_dir=NULL, suffix = "") {
  stats_data = as.data.frame(stats_data)
  res = data.frame()
  for (variable in var_columns) {
    #pass if variable does not exist
    if (!variable %in% colnames(stats_data)) 
      next
    for (g in unique(class_col)) {
      a_indexes = stats_data[class_col == g,variable]
      if (length(na.omit(a_indexes)) > 3 & unique(na.omit(a_indexes)) > 1) 
        pval = statistical_test(a_indexes)$p.value
      else
        pval = NA
      
      res = rbind(res, as.data.frame(list(TestedValue = g,
                                          Variable = variable,
                                          # MeanIndexA = mean_a,
                                          # MeanIndexB = mean_b,
                                          # StdIndexA = std_a,
                                          # StdIndexB = std_b,
                                          PValue = signif(pval, digits = 4))))
    }
  }
  if (is.null(stats_output_dir) & is.null(correction_method))
    return(res) 
  if (is.null(stats_output_dir))
    return(res %>% group_by(Variable) %>% mutate(PValueAdjusted = p.adjust(PValue, method = correction_method))) 
  stats_output_format(stats_output_dir = stats_output_dir, res = res, test = statistical_test, correction_method = correction_method, suffix = suffix)  
  
}
