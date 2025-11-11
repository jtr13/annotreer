# Create Annotated Labels for rpart Trees

Generates custom labels for each node in an `rpart` classification tree
to aid in understanding CART's pruning algorithm

## Usage

``` r
annotree(
  mod,
  show_classes = TRUE,
  show_gt = FALSE,
  show_cp = FALSE,
  show_pruned = FALSE,
  show_min = FALSE,
  show_leaf_dev = FALSE,
  show_internal_dev = FALSE,
  main = NULL
)
```

## Arguments

- mod:

  an `rpart` object

- show_classes:

  logical. If `TRUE` show class labels and counts. Defaults to `TRUE`.

- show_gt:

  logical. If `TRUE` the g(t) term (misclassification reduction per
  split) is included. Defaults to `FALSE`.

- show_cp:

  logical. If `TRUE` the complexity parameter (cp) value, calculated as
  g(t) divided by root node deviance is included. Defaults to `FALSE`.

- show_pruned:

  logical. If `TRUE` the nodes slated for pruning are plotted in a
  distinct color. Defaults to `FALSE`.

- show_min:

  logical. If `TRUE` the node with minimum g(t) is labeled "\*minimum".
  Defaults to `FALSE`.

- show_leaf_dev:

  logical. If `TRUE` leaves are labeled with "dev" (misclassified
  cases). Defaults to `FALSE`.

- show_internal_dev:

  logical. If `TRUE` internal nodes are labeled with "dev"
  (misclassified cases). Defaults to `FALSE`.

- main:

  An optional title for the plot.

## Details

This function is primarily used to create informative labels for
internal nodes and leaves in classification trees.

- For leaf nodes, it displays the word `"leaf"` and the node's deviance.

- For internal nodes, it can display the g(t) equation, cp value, and
  optionally indicate the node with the smallest g(t).

## Examples

``` r
library(rpart)
kmod <- rpart(Kyphosis ~ Age + Number + Start, data = kyphosis, cp = 0, minsplit = 2)
annotree(kmod)

```
