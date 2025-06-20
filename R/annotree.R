#' Create Annotated Labels for rpart Trees
#'
#' Generates custom labels for each node in an `rpart` classification tree to aid
#' in understanding CART's pruning algorithm
#'
#' @param mod an `rpart` object
#' @param gt logical. If `TRUE` the g(t) term (misclassification reduction per split) is included. Defaults to `FALSE`.
#' @param cp logical. If `TRUE` the complexity parameter (cp) value, calculated as g(t) divided by root node deviance is included. Defaults to `TRUE`.
#' @param showpruned logical. If `TRUE` the nodes slated for pruning are plotted in a distinct color. Defaults to `TRUE`.
#' @param showmin logical. If `TRUE` the node with minimum g(t) is labeled "*minimum". Defaults to `TRUE`.
#' @param main An optional title for the plot.
#'
#' @details
#' This function is primarily used to create informative labels for internal nodes and leaves in classification trees.
#' - For leaf nodes, it displays the word `"leaf"` and the node's deviance.
#' - For internal nodes, it can display the g(t) equation, cp value, and optionally indicate the node with the smallest g(t).
#'
#' @examples
#' library(rpart)
#' kmod <- rpart(Kyphosis ~ Age + Number + Start, data = kyphosis, cp = 0, minsplit = 2)
#' annotree(kmod)
#'
#' @export


annotree <- function(mod, gt = FALSE, cp = TRUE, showpruned = TRUE,
                     showmin = TRUE, main = NULL) {
  mod$frame <- annotate_gt(mod)
  mod$frame$nn <- as.numeric(rownames(mod$frame))
  mod$frame$label <- create_label(mod, gt = gt, cp = cp, showmin = showmin)
  mod$frame$colors <- gt_calc_colors(mod, showpruned = showpruned)
  rpart.plot::prp(mod, extra = 1, type = 2,
      node.fun = node.label,
      nn = TRUE, box.col = mod$frame$colors)
  if (!is.null(main)) mtext(main, side = 3, line = 3, font = 2, cex = 1.2)

}


