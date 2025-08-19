## -----------------------------------------------------------------------------
#| label: carbon
#| message: false
library(hockeystick)
ml_co2 <- get_carbon()
plot_carbon(ml_co2)


## -----------------------------------------------------------------------------
#| label: emissions
#| message: false
emissions <- get_emissions()
plot_emissions(emissions)
plot_emissions_with_land(emissions)


## -----------------------------------------------------------------------------
#| label: emissionsmap
#| message: false
emissions_map()


## -----------------------------------------------------------------------------
#| label: anomaly
#| message: false
anomaly <- get_temp()
plot_temp(anomaly)


## -----------------------------------------------------------------------------
#| label: tempcarbon
#| message: false
plot_carbontemp()


## -----------------------------------------------------------------------------
#| label: stripes
#| message: false
warming_stripes()
warming_stripes(stripe_only = TRUE, col_strip = viridisLite::viridis(11))


## -----------------------------------------------------------------------------
#| label: sealevel
#| message: false
gmsl <- get_sealevel()
plot_sealevel(gmsl)


## -----------------------------------------------------------------------------
#| label: ice
#| message: false
seaice <- get_seaice()
plot_seaice(seaice)


## -----------------------------------------------------------------------------
#| label: ice2
#| message: false
arcticice <- get_icecurves()
plot_icecurves(arcticice)


## -----------------------------------------------------------------------------
#| label: hurdat
#| message: false
hurricanes <- get_hurricanes()
plot_hurricanes(hurricanes)
plot_hurricane_nrg(hurricanes)


## -----------------------------------------------------------------------------
#| label: methane
#| message: false
ch4 <- get_methane()
plot_methane(ch4)


## -----------------------------------------------------------------------------
#| label: paleo
#| message: false
vostok <- get_paleo()
plot_paleo(vostok)

