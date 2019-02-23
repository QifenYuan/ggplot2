#' @include stat-.r
NULL

#' @export
#' @rdname geom_abline
geom_hline <- function(mapping = NULL, data = NULL,
                       ...,
                       yintercept,
                       na.rm = FALSE,
                       show.legend = NA) {

  # Act like an annotation
  if (!missing(yintercept)) {
    # Warn if supplied mapping is going to be overwritten
    if (!missing(mapping)) {
      warning(paste0("Using both `yintercept` and `mapping` may not have the",
                     " desired result as mapping is overwritten if",
                     " `yintercept` is specified\n"
              )
      )
    }
    data <- new_data_frame(list(yintercept = yintercept))
    mapping <- aes(yintercept = yintercept)
    show.legend <- FALSE
  }

  layer(
    data = data,
    mapping = mapping,
    stat = StatIdentity,
    geom = GeomHline,
    position = PositionIdentity,
    show.legend = show.legend,
    inherit.aes = FALSE,
    params = list(
      na.rm = na.rm,
      ...
    )
  )
}

#' @rdname ggplot2-ggproto
#' @format NULL
#' @usage NULL
#' @export
GeomHline <- ggproto("GeomHline", Geom,
  draw_panel = function(data, panel_params, coord) {
    ranges <- coord$backtransform_range(panel_params)

    data$x    <- ranges$x[1]
    data$xend <- ranges$x[2]
    data$y    <- data$yintercept
    data$yend <- data$yintercept

    GeomSegment$draw_panel(unique(data), panel_params, coord)
  },

  default_aes = aes(colour = "black", size = 0.5, linetype = 1, alpha = NA),
  required_aes = "yintercept",

  draw_key = draw_key_path
)
