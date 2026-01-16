lilien_index <- function(data, sector, time, value) {
  
  library(dplyr)
  
  data <- data %>%
    arrange({{ sector }}, {{ time }}) %>%
    dplyr::group_by({{ time }})
  
  lilien_index <- data %>%
    dplyr::mutate(s_sum1 = sum({{ value }}, na.rm = TRUE),
           share1 = {{ value }}/s_sum1 * 100) %>%
    dplyr::ungroup() %>%
    dplyr::group_by({{ sector }}) %>%
    # Lag sectoral employment
    dplyr::mutate(l.value = dplyr::lag({{ value }}, n = 1, default = NA, order_by = date),
           l.s_sum1 = dplyr::lag(s_sum1, n = 1, default = NA, order_by = date)) %>%
    dplyr::ungroup() %>%
    dplyr::group_by({{ time }}) %>%
    # Compute sectoral growth
    dplyr::mutate(sgrowth1 = log(s_sum1/l.s_sum1),
           igrowth1 = log({{ value }}/l.value)) %>%
    dplyr::group_by({{ time }}) %>%
    # Compute final Lilien Index
    dplyr::summarise(index1 = sum(((igrowth1 - sgrowth1)^2)*share1),
              LI = sqrt(index1)) %>%
    dplyr::select({{ time }}, LI)
  
  return(lilien_index)
}

