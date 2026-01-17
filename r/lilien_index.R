#' Calculate the Lilien Index of Sectoral Employment Dispersion
#' #' @references
#' Lilien, D.M. (1982). Sectoral Shifts and Cyclical Unemployment.
#' Journal of Political Economy, 90(4), 777-793.
#' @param data A data frame containing panel data with sectors over time
#' @param sector Unquoted column name identifying sectors
#' @param time Unquoted column name for time periods (must be sortable)
#' @param value Unquoted column name for employment values
#'
#' @return A tibble with columns for time period and Lilien Index (LI)
#' @export
lilien_index <- function(data, sector, time, value) {
  
  # Input validation
  if (!is.data.frame(data)) {
    stop("'data' must be a data frame")
  }
  
  # Sort by sector and time for correct lag calculation
  result <- data %>%
    arrange({{ sector }}, {{ time }}) %>%
    dplyr::group_by({{ time }}) %>%
    # Step 1: Calculate total employment (X_t) for each time period
    dplyr::mutate(X_t = sum({{ value }}, na.rm = TRUE),
                  # Employment share s_it = x_it / X_t (as proportion, not percentage)
                  share1 = {{ value }}/X_t * 100) %>%
    
    dplyr::ungroup() %>%
    dplyr::group_by({{ sector }}) %>%
    # Step 2: Calculate lagged values within each sector
    dplyr::mutate(l.value = dplyr::lag({{ value }}, n = 1, default = NA, order_by = {{ time }}),
                  l.X_t = dplyr::lag(X_t, n = 1, default = NA, order_by = {{ time }})) %>%
    dplyr::ungroup() %>%
    dplyr::group_by({{ time }}) %>%
    # Step 3: Calculate growth rates
    dplyr::mutate(# Aggregate growth: G_t = ln(X_t / X_t-1),
                  aggregate_growth = log(X_t/l.X_t),
                  # Sectoral growth: g_it = ln(x_it / x_i,t-1)
                  sector_growth = log({{ value }}/l.value)) %>%
    dplyr::group_by({{ time }}) %>%
    # Step 4: Compute Lilien Index for each time period
    # LI_t = sqrt( sum_i [ s_it * (g_it - G_t)^2 ] )
    dplyr::summarise(index1 = sum(((sector_growth - aggregate_growth)^2)*share1),
              LI = sqrt(index1)) %>%
    
    dplyr::select({{ time }}, LI)
  
  return(result)
}


