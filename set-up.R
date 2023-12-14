#Download and save QoG dataset:

qog_folder <- file.path(downloaded_DHS_data_file_path, "qog")
dir.create(qog_folder)
download.file("https://www.qogdata.pol.gu.se/data/qog_std_ts_jan22.sav",
              qog_folder)