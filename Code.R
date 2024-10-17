# 1. Load Libraries
install.packages("pacman")
pacman::p_load(
    geodata,
    sf,
    elevatr,
    terra,
    tidyverse,
    rayshader,
    scales
)

# 2. Set Working Directory for OSM Road Data
main_path <- getwd()
nepal_dir <- file.path(main_path, "nepal_osm_roads")
if (!dir.exists(nepal_dir)) dir.create(nepal_dir)
setwd(nepal_dir)

# 3. Download and Extract OSM Road Data for Nepal
url <- "https://download.geofabrik.de/asia/nepal-latest-free.shp.zip"
destfile <- basename(url)
if (!file.exists(destfile)) download.file(url, destfile, mode = "wb")
unzip(destfile, exdir = nepal_dir)

# 4. Load Road Shapefile
road_files <- list.files(nepal_dir, pattern = "roads.*\\.shp$", full.names = TRUE)
road_sf <- sf::st_read(road_files[1])

# 5. Download Nepal Boundary (GADM)
country_sf <- geodata::gadm("NPL", level = 0, path = getwd()) |> sf::st_as_sf()

# 6. Download Elevation Data (DEM) for Nepal
elev <- elevatr::get_elev_raster(locations = country_sf, z = 8, clip = "locations")

# 7. Project DEM to LAEA Projection
crs_laea <- "+proj=laea +lat_0=28 +lon_0=84 +datum=WGS84"
elev_lambert <- terra::project(terra::rast(elev), crs_laea)

# 8. Convert DEM to Matrix for 3D Visualization
elmat <- rayshader::raster_to_matrix(elev_lambert)

# 9. Filter and Simplify Road Data
roads_filtered <- road_sf |>
    dplyr::filter(fclass %in% c("primary", "secondary", "tertiary", "residential")) |>
    sf::st_intersection(country_sf) |>
    sf::st_transform(crs_laea)

# 10. Set Up Color Palette and New HDR Environment for Important Road Map
elevation_colors <- c("blue", "green", "yellow", "brown", "white")
hdr_url <- "https://dl.polyhaven.org/file/ph-assets/HDRIs/hdr/4k/studio_small_04_4k.hdr"
hdri_file <- basename(hdr_url)
if (!file.exists(hdri_file)) download.file(hdr_url, hdri_file, mode = "wb")

# 11. Render 3D Scene with Road Overlay and New HDR Lighting for Important Road Map
elmat |>
    rayshader::height_shade(texture = colorRampPalette(elevation_colors)(128)) |>
    rayshader::add_overlay(
        rayshader::generate_line_overlay(
            geometry = roads_filtered,
            extent = elev_lambert,
            heightmap = elmat,
            color = "red",  # Road color set to red for clear visibility
            linewidth = 3
        ),
        alphalayer = 1
    ) |>
    rayshader::plot_3d(
        elmat,
        zscale = 8,
        solid = FALSE,
        shadow = TRUE,
        shadow_darkness = 0.3,
        background = "white",
        windowsize = c(800, 600),
        zoom = 0.6,
        phi = 89,
        theta = 0
    )

# 12. Save High-Quality Rendered Image with Studio Lighting HDR
output_file <- "3d_road_map_nepal_studio_lighting.png"
rayshader::render_highquality(
    filename = output_file,
    preview = TRUE,
    interactive = FALSE,
    light = TRUE,
    environment_light = hdri_file,
    intensity_env = 0.8,  # Slightly higher intensity for studio lighting
    width = 900,
    height = 600,
    line_radius = 7
)
