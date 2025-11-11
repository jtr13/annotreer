#' Create Annotated Labels for rpart Trees
#'
#' Generates custom labels for each node in an `rpart` classification tree to aid
#' in understanding CART's pruning algorithm
#'
#' @param mod an `rpart` object
#' @param show_classes logical. If `TRUE` show class labels and counts. Defaults to `TRUE`.
#' @param show_gt logical. If `TRUE` the g(t) term (misclassification reduction per split) is included. Defaults to `FALSE`.
#' @param show_cp logical. If `TRUE` the complexity parameter (cp) value, calculated as g(t) divided by root node deviance is included. Defaults to `FALSE`.
#' @param show_pruned logical. If `TRUE` the nodes slated for pruning are plotted in a distinct color. Defaults to `FALSE`.
#' @param show_min logical. If `TRUE` the node with minimum g(t) is labeled "*minimum". Defaults to `FALSE`.
#' @param show_leaf_dev logical. If `TRUE` leaves are labeled with "dev" (misclassified cases). Defaults to `FALSE`.
#' @param show_internal_dev logical. If `TRUE` internal nodes are labeled with "dev" (misclassified cases). Defaults to `FALSE`.
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


annotree <- function(mod, show_classes = TRUE,
                     show_gt = FALSE, show_cp = FALSE, show_pruned = FALSE,
                     show_min = FALSE, show_all_dev = FALSE,
                     show_leaf_dev = FALSE,
                     show_internal_dev = FALSE, main = NULL) {
  if(show_classes & (mod$method != "class")) {
    message("`show_classes` only works with classification trees.")
    show_classes <- FALSE
  }
  if (show_all_dev) {
    show_leaf_dev <- TRUE
    show_internal_dev <- TRUE
  }
  
  mod$frame <- annotate_gt(mod)
  mod$frame$nn <- as.numeric(rownames(mod$frame))
  mod$frame$label <- create_label(mod, show_classes = show_classes,
                                  show_gt = show_gt, show_cp = show_cp,
                                  show_leaf_dev = show_leaf_dev,
                                  show_internal_dev = show_internal_dev,
                                  show_min = show_min)
  mod$frame$colors <- gt_calc_colors(mod, show_pruned = show_pruned)
  rpart.plot::prp(mod, extra = 1, type = 2,
      node.fun = node.label,
      nn = TRUE, box.col = mod$frame$colors)
  if (!is.null(main)) mtext(main, side = 3, line = 3, font = 2, cex = 1.5)

}


