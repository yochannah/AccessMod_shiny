#         ___                                  __  ___            __   ______
#        /   |  _____ _____ ___   _____ _____ /  |/  /____   ____/ /  / ____/
#       / /| | / ___// ___// _ \ / ___// ___// /|_/ // __ \ / __  /  /___ \
#      / ___ |/ /__ / /__ /  __/(__  )(__  )/ /  / // /_/ // /_/ /  ____/ /
#     /_/  |_|\___/ \___/ \___//____//____//_/  /_/ \____/ \__,_/  /_____/
#
#    AccessMod 5 Supporting Universal Health Coverage by modelling physical accessibility to health care
#    
#    Copyright (c) 2014-2020  WHO, Frederic Moser (GeoHealth group, University of Geneva)
#    
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#    
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#    
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <https://www.gnu.org/licenses/>.

library("checkpoint")

#
# shortcut to test if package exists
#

library <- function(pkgName=NULL){
  base::library(pkgName,logical.return=T,character.only=T)
}


# Option list for packge provisionning
#
opt <- list(
  # Path to the checkpoint installation
  pathFull = normalizePath("~/.am5/.checkpoint",mustWork=F),
  pathBase =  normalizePath("~/.am5/",mustWork=F),
  # Date of the CRAN checkpoint
  date = "2016-11-30",
  # Version of R used. 
  version = paste(R.version$major,R.version$minor,sep="."),
  platform = R.version$platform,
  packageOk = FALSE,
  libraryOk = FALSE
  )

opt$libPaths = c(
  file.path(
    opt$pathFull,opt$date,
    "lib",
    opt$platform,
    opt$version
    ),
  file.path(
    opt$pathFull,
    paste0("R-",opt$version)
    )
  )

opt$libraryOk = all(
  sapply(
    opt$libPaths,
    dir.exists
    )
  )

if( opt$libraryOk ){
  .libPaths( opt$libPaths )
  suppressWarnings(
    suppressMessages({
      pkgs = c(
        library("parallel")
        , library("tools")
        , library("shiny")
        # used in GIS preview
        , library("leaflet")
        # used in amReadLogs to read last subset lines
        , library("R.utils")
        # R interface to GRASS GIS
        , library("rgrass7")
        # provide fast tabular data manipulation #NOTE: Used only in referral analysis ! use dplyr ?
        , library("data.table")
        # raster manipulation, import, get info without loading file.
        , library("raster")
        # ldply in handson table (amHandson, logical.return=T,character.only=T)
        , library("plyr")
        # used for anti_join in amUpdateDataListName.  
        , library("dplyr")
        # complete access to system GDAL. 
        , library("gdalUtils")
        # map display. Used in project mondue
        , library("maps")
        # R interface to DBI library for SQLITE. Used to check grass db without grass.
        , library("RSQLite")
        # Imported by RSQLite. Used to cache values. E.g. Stack conflict validation in merge LDC
        , library("memoise")
        # admin LTE/bootstrap template
        , library("shinydashboard")
        # geojson process. Used in gis preview
        , library("geojsonio")
        #Swiss-army knife for data I/O
        , library("rio")
        # used in GIS preview for gintersection
        , library("rgeos")
        , library("stringr")
        )
      # dependencies

      opt$packagesOk <- all(pkgs)
    }))
}

if( !isTRUE(opt$packagesOk) || !isTRUE(opt$libraryOk) ){

  warning("Packges list or library path is not set, this could take a while")

  dir.create(
    path=opt$pathFull,
    recursive=TRUE,
    showWarnings=FALSE
    )

  checkpoint(
    snapshotDate = opt$date,
    checkpointLocation = opt$pathBase,
    scanForPackages = TRUE
    )

  source("global.R")
}




#
# load configuration file
#

source("config/config-app.R")

#
# WARNING devtools and load_all mess with data.table object ! 
#
source('tools/R/amFunctions.R') 
source('tools/R/amSpeedBufferRegion.R')
source('tools/R/amUpdate.R')
source('tools/R/amGrassLeaflet.R') 
source('tools/R/amTranslate.R') 
source('tools/R/amMapsetTools.R') 
source('tools/R/amFacilitiesTools.R')
source('tools/R/amProgress.R')
source('tools/R/amDebounce.R')
source('tools/R/amShinyBindings.R')
source('tools/R/amDataManage.R')
source('tools/R/amAnalysisTravelTime.R')
source('tools/R/amAnalysisZonal.R')
source('tools/R/amAnalysisCatchment.R')
source('tools/R/amAnalysisCapacity.R')
source('tools/R/amAnalysisReplay.R')
source('tools/R/amProjectImportExport.R')
source('tools/R/amAnalysisReferralParallel.R')
source('tools/R/amAnalysisTimeDist.R')
source('tools/R/amAnalysisScalingUp.R')
source('tools/R/amHandson.R')
source('tools/R/amUi.R')
source('tools/R/amUi_doubleSortableInput.R')
#
# Memoize manager
#
source('tools/R/amMemoised.R')

#
# Set GRASS verbose level
#

if( "debug" %in% config$logMode ){
  Sys.setenv(GRASS_VERBOSE=1)
}else if("perf" %in% config$logMode){
  Sys.setenv(GRASS_VERBOSE=-1)
}else{
  Sys.setenv(GRASS_VERBOSE=0)
}

