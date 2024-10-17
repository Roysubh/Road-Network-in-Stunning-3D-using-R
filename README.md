# Road-Network-in-Stunning-3D-using-R

Overview:
This project demonstrates how to create a 3D visualization of Nepal's road network using Digital Elevation Model (DEM) data and OpenStreetMap (OSM) road data. We utilize R for spatial data processing and 3D rendering with the rayshader package.

Prerequisites:
Ensure you have R installed, along with the following libraries:

pacman
sf
terra
elevatr
rayshader
scales
tidyverse

Steps:
1. Install and Load Libraries
Start by loading the necessary libraries in R.

2. Set Working Directory for OSM Road Data
Create a working directory to store the downloaded OSM road data for Nepal.

3. Download and Prepare OSM Road Data for Nepal
Download the OSM road shapefile for Nepal from Geofabrik.
Unzip and load the road shapefile into R.
4. Get Country Boundary Data for Nepal
Download Nepal's country boundary using the GADM dataset. This will help filter the road data to the country's extent.

5. Download Digital Elevation Model (DEM) Data
Download DEM data for Nepal, ensuring it is clipped to the country boundary. This data provides the elevation context for the road visualization.

6. Reproject DEM Data (Optional)
Reproject the DEM to Lambert Azimuthal Equal Area (LAEA) projection to improve the spatial representation of the data. This step is optional but can enhance visualization accuracy.

7. Simplify and Filter Road Data
Filter the road data to keep only relevant road classes (e.g., "primary", "secondary", "tertiary", "residential"). Simplify and reproject the road shapefile for better compatibility with the DEM data.

8. Convert DEM Data to Matrix
Convert the reprojected DEM raster to a matrix format suitable for visualization using the rayshader package.

9. Render 3D Map and Overlay Road Data
Use rayshader to create a 3D visualization of the DEM. Overlay the road data on top of the DEM to provide context to the elevation.

10. Render and Save High-Quality Image
Save the rendered 3D map as a high-quality image, applying HDR lighting to enhance the visual output.

Conclusion:
This project demonstrates how to create a 3D visualization of the road network in Nepal using DEM and OSM data in R. 
By following these steps, you can replicate similar visualizations for other regions by modifying the country boundary and OSM data.

Optional: 
Download OSM Data from Geofabrik
You can download OSM data for other regions from Geofabrik using the following link: (https://download.geofabrik.de/)
