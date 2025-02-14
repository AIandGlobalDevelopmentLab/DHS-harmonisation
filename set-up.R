#Make folders if they don't exist:
create_folder <- function(folder_path) {
  if (!dir.exists(folder_path)) {
    dir.create(folder_path, recursive = TRUE)
  }
}

create_folder(downloaded_DHS_data_file_path)
create_folder(harmonised_DHS_data_file_path)

if (!dir.exists(repo_file_path)) {
  stop("The folder containing the DHS-harmonisation repository does not exist.")
} 


#Download and save QoG dataset:

qog_folder <- file.path(downloaded_DHS_data_file_path, "qog")
create_folder(qog_folder)
download.file("https://www.qogdata.pol.gu.se/data/qog_std_cs_jan25.sav",
              file.path(qog_folder, "qog_std_cs_jan25.sav"))

              