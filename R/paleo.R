#' Download and plot essential climate data
#'
#' Retrieves historical carbon dioxide and temperature records from the Vostok ice core during the past 420,000 years.
#' Source of data is the U.S. Department of Energy’s (DOE) Environmental System Science Data Infrastructure for a Virtual Ecosystem (ESS-DIVE).
#' \url{https://ess-dive.lbl.gov/} and \url{https://data.ess-dive.lbl.gov/datasets/doi:10.3334/CDIAC/CLI.006}
#'
#' @name get_paleo
#' @param use_cache (boolean) Return cached data if available, defaults to TRUE. Use FALSE to fetch updated data.
#' @param write_cache (boolean) Write data to cache, defaults to FALSE. Use TRUE to write data to cache for later use. Can also be set using options(hs_write_cache=TRUE)
#'
#' @return Invisibly returns a tibble with the age of the ice (years before C.E.), carbon dioxide (ppm) and temperature (degrees C).
#'
#' `get_paleo` invisibly returns a tibble with Vostok ice core data: the age of the ice (years before C.E.), carbon dioxide (ppm) and temperature (degrees C).
#'
#' Data are from: Barnola J; Raynaud D; Lorius C; Barkov N  (2003): Historical Carbon Dioxide Record from the Vostok Ice Core (417,160 - 2,342 years BP) and
#' Petit J R ; Raynaud D ; Lorius C ; Delaygue G ; Jouzel J ; Barkov N I ; Kotlyakov V M  (2000): Historical Isotopic Temperature Record from the Vostok Ice Core. CDIAC.
#'
#' @importFrom readr read_table
#' @importFrom utils download.file
#' @importFrom dplyr full_join select
#' @importFrom tidyr pivot_longer
#'
#' @examples
#' \donttest{
#' # Fetch Vostok paleo carbon and temperature data from cache if available:
#' vostok <- get_paleo()
#' #
#' # Force cache refresh:
#' vostok <- get_paleo(use_cache=FALSE)
#' #
#' # Review cache contents and last update dates:
#' hockeystick_cache_details()
#' #
#' # Plot output using package's built-in ggplot2 settings
#' plot_paleo(vostok) }
#'
#' @author Hernando Cortina, \email{hch@@alum.mit.edu}
#' @references
#' \itemize{
#' \item Historical Carbon Dioxide Record from the Vostok Ice Core (US Dept of Energy): \url{https://data.ess-dive.lbl.gov/datasets/doi:10.3334/CDIAC/CLI.006}
#' \item Petit J R ; Raynaud D ; Lorius C ; Delaygue G ; Jouzel J ; Barkov N I ; Kotlyakov V M  (2000): Historical Isotopic Temperature Record from the Vostok Ice Core. CDIAC. doi:10.3334/CDIAC/CLI.006. \url{https://data.ess-dive.lbl.gov/view/doi:10.3334/CDIAC/CLI.006}
#' \item Barnola J ; Raynaud D ; Lorius C ; Barkov N  (2003): Historical Carbon Dioxide Record from the Vostok Ice Core (417,160 - 2,342 years BP). None. doi:10.3334/CDIAC/ATG.009 \url{https://data.ess-dive.lbl.gov/view/doi:10.3334/CDIAC/ATG.009}
#'  }
#'
#' @export


get_paleo <- function(use_cache = TRUE, write_cache = getOption("hs_write_cache")) {

  hs_path <- tools::R_user_dir("hockeystick","cache")

  if (use_cache) {
    if (file.exists(file.path(hs_path,'paleo.rds'))) return(invisible(readRDS((file.path(hs_path,'paleo.rds')))))
  }

file_url <- 'https://data.ess-dive.lbl.gov/catalog/d1/mn/v2/object/ess-dive-457358fdc81d3a5-20180726T203952542'
connected <- .isConnected(file_url)
if (!connected) {message("Retrieving remote data requires internet connectivity."); return(invisible(NULL))}

dl <- tempfile()
download.file(file_url, dl)
vostok <- readr::read_table(dl, col_names = FALSE, skip = 21, show_col_types = FALSE)
colnames(vostok) <- c('depth', 'age_ice', 'age_air', 'co2')

file_url <- 'https://data.ess-dive.lbl.gov/catalog/d1/mn/v2/object/ess-dive-1e57f3f83864c10-20180717T104354142744'
connected <- .isConnected(file_url)
if (!connected) {message("Retrieving remote data requires internet connectivity."); return(invisible(NULL))}

dl <- tempfile()
download.file(file_url, dl)
paleotemp <- readr::read_table(dl, col_names = FALSE, skip = 60, show_col_types = FALSE)
colnames(paleotemp) <- c('depth', 'age_ice', 'deuterium', 'temp')

suppressMessages( paleo <- dplyr::full_join(vostok, paleotemp) )
paleo <- dplyr::select(paleo, age_ice, co2, temp)
paleo <- tidyr::pivot_longer(paleo, -age_ice, values_drop_na = TRUE)

if (write_cache) saveRDS(paleo, file.path(hs_path, 'paleo.rds'))

invisible(paleo) }

#' Download and plot essential climate data
#'
#' Plots the Vostok ice core data retrieved using `get_paleo()` with ggplot2. The output ggplot2 object may be further modified.
#'
#'
#' @name plot_paleo
#' @param dataset Name of the tibble generated by `get_paleo`, defaults to calling `get_paleo`
#' @param print (boolean) Display Vostok ice core ggplot2 chart, defaults to TRUE. Use FALSE to not display chart.
#'
#' @return Invisibly returns a ggplot2 object with the Vostok chart
#'
#' @details `plot_paleo` invisibly returns a ggplot2 object with a pre-defined Vostok ice core chart using data from `get_paleo`.
#' The returned chart stacks carbon dioxide concentration over temperature over 420,000 years.
#' By default the chart is also displayed. Users may further modify the output ggplot2 chart.
#'
#' @import ggplot2
#' @importFrom patchwork wrap_plots
#' @importFrom scales unit_format
#'
#' @examples
#' \donttest{
#' # Fetch Vostok data:
#' vostok <- get_paleo()
#' #
#' # Plot output using package's built-in ggplot2 defaults
#' plot_paleo(vostok)
#'
#' # Or just call plot_paleo(), which defaults to get_paleo() dataset
#' plot_paleo()
#'
#' p <- plot_paleo(vostok, print = FALSE)
#' # Modify plot such as: p + patchwork::plot_annotation(title='A Long History of Carbon') }
#'
#' @author Hernando Cortina, \email{hch@@alum.mit.edu}
#' @references
#' Barnola, J.-M., D. Raynaud, C. Lorius, and N.I. Barkov. 2003. Historical CO2 record from the Vostok ice core. In Trends: A Compendium of Data on Global Change. Carbon Dioxide Information Analysis Center, Oak Ridge National Laboratory, U.S. Department of Energy, Oak Ridge, Tenn., U.S.A
#'
#' @export

plot_paleo <- function(dataset = get_paleo(), print=TRUE) {

if (is.null(dataset)) return(invisible(NULL))

a <- ggplot(dataset[dataset$name=='co2',], aes(x=age_ice, y=value)) +geom_line(linewidth=.8, col='firebrick1') +scale_x_reverse(lim=c(423000,0)) +
            theme_bw() + theme(axis.title.x=element_blank(), axis.text.x=element_blank()) +labs(y=expression(CO[2]*' concentration' ))

b <- ggplot(dataset[dataset$name=='temp',], aes(x=age_ice, y=value)) +geom_line(linewidth=.8, col='dodgerblue2') +scale_x_reverse(lim=c(423000, 0), labels = scales::unit_format(unit='', scale = 1e-3)) +
            labs(x='Millennia before present', y='Temperature (C\U00B0)') +theme_bw()

plot <- patchwork::wrap_plots(a, b, ncol=1) + patchwork::plot_annotation(title = expression('Paleoclimate: The Link Between '*CO[2]*' and Temperature'),
      caption = 'Source: U.S. Department of Energy ESS-DIVE\nhttps://data.ess-dive.lbl.gov/datasets/doi:10.3334/CDIAC/ATG.009\nhttps://data.ess-dive.lbl.gov/datasets/doi:10.3334/CDIAC/CLI.006',
      subtitle='420,000 years from the Vostok ice core, Antarctica.', theme = theme(  plot.title = element_text(size = 14)))

if (print) suppressMessages( print(plot) )
invisible(plot)
}

