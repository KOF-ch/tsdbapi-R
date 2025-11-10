devtools::load_all()
set_config(environment = "test")

list_users()
list_user_access_sets("heidi")

list_collections()
# Create collection for other owner
create_collection("globalbaro_test", owner = "test-owner", description = "this is a test collection")
add_ts_to_collection("globalbaro_test", c("ch.kof.globalbaro.coincident", "missing"), owner = "test-owner")
add_ts_to_collection("globalbaro_test", c("ch.kof.globalbaro.coincident", "missing"), owner = "test-owner", ignore_missing = T)
read_collection_keys("globalbaro_test", owner = "test-owner")
add_ts_to_collection("globalbaro_test", c("ch.kof.globalbaro.coincident", "ch.kof.globalbaro.leading"), owner = "test-owner")
read_collection_keys("globalbaro_test", owner = "test-owner")
remove_ts_from_collection("globalbaro_test", c("ch.kof.globalbaro.coincident","ch.kof.globalbaro.leading"), owner = "test-owner")
read_collection_keys("globalbaro_test", owner = "test-owner")
delete_collection("globalbaro_test", owner = "test-owner")
read_collection_keys("globalbaro_test", owner = "test-owner")
read_collection_ts("globalbaro_test", owner = "test-owner")
delete_collection("globalbaro_test", owner = "test-owner")
# Delete non-existing collection
delete_collection("globalbaro_test", owner = "test-owner")

# Create collection for user
create_collection("globalbaro_test", description = "this is a test collection")
# Add missing keys
add_ts_to_collection("globalbaro_test", c("ch.kof.globalbaro.coincident", "missing"))
add_ts_to_collection("globalbaro_test", c("ch.kof.globalbaro.coincident", "missing"), ignore_missing = T)
read_collection_keys("globalbaro_test")
add_ts_to_collection("globalbaro_test", c("ch.kof.globalbaro.coincident", "ch.kof.globalbaro.leading"))
read_collection_keys("globalbaro_test")
remove_ts_from_collection("globalbaro_test", c("ch.kof.globalbaro.coincident","ch.kof.globalbaro.leading"))
read_collection_keys("globalbaro_test")
delete_collection("globalbaro_test")
read_collection_keys("globalbaro_test")


list_datasets()
create_dataset("test-dataset", "this is a test dataset")
delete_dataset("test-dataset")
read_ts_dataset(c("ch.kof.globalbaro.coincident", "ch.kof.globalbaro.leading"))
write_ts_dataset(c("ch.kof.globalbaro.coincident", "ch.kof.globalbaro.leading"), "test-dataset")
read_dataset_keys("test-dataset")
read_dataset_ts("test-dataset")
read_dataset_ts_metadata("test-dataset", locale = "fr")
write_ts_dataset(c("ch.kof.globalbaro.coincident", "ch.kof.globalbaro.leading"), "ch.kof.globalbaro")
read_ts_dataset(c("ch.kof.globalbaro.coincident", "ch.kof.globalbaro.leading"))


list_access_sets()
create_access_set("test-access-set", "this is a test accesss set")
delete_access_set("test-access-set")
list_access_sets()
create_access_set("test-access-set", "this is a test accesss set")
add_ts_to_access_set("test-access-set", c("ch.kof.globalbaro.coincident","ch.kof.globalbaro.leading"))
read_access_set_keys("test-access-set")
remove_ts_from_access_set("test-access-set", c("ch.kof.globalbaro.coincident"))
read_access_set_keys("test-access-set")
add_ts_to_access_set("test-access-set", c("ch.kof.globalbaro.coincident","ch.kof.globalbaro.leading"))
delete_access_set("test-access-set")
read_access_set_keys("test-access-set")

create_access_set("test-access-set-1", "this is a test access set")
add_ts_to_access_set("test-access-set-1", c("ch.kof.globalbaro.coincident","ch.kof.globalbaro.leading"))
create_access_set("test-access-set-2", "this is a test access set")
add_ts_to_access_set("test-access-set-2", c("ch.kof.globalbaro.europe.coincident","ch.kof.globalbaro.europe.leading"))
create_access_set("test-access-set-3", "this is a test access set")
add_ts_to_access_set("test-access-set-3", c("ch.kof.globalbaro.west.coincident","ch.kof.globalbaro.west.leading"))

list_users()

add_user_access_sets("heidi", "test-access-set-1", "read")
add_user_access_sets("heidi", "test-access-set-2", "read_before_release")
add_user_access_sets("heidi", "test-access-set-3", "write")
add_user_access_sets("sepp", "test-access-set-1", "read")
add_user_access_sets("sepp", "test-access-set-2", "read_before_release")
add_user_access_sets("sepp", "test-access-set-3", "write")


devtools::load_all()
set_config(environment = "test")

delete_access_set("test-access-set-read")
delete_access_set("test-access-set-read_before_release")
delete_access_set("test-access-set-write")
delete_access_set("test-access-set-none")

list_access_sets()
list_user_access_sets("heidi")
list_user_access_sets("sepp")

create_access_set("test-access-set-read", "this is a test access set")
add_user_access_sets("heidi", "test-access-set-read", "read")
add_user_access_sets("sepp", "test-access-set-read", "read")

create_access_set("test-access-set-read_before_release", "this is a test access set")
add_user_access_sets("heidi", "test-access-set-read_before_release", "read_before_release")
add_user_access_sets("sepp", "test-access-set-read_before_release", "read_before_release")

create_access_set("test-access-set-write", "this is a test access set")
add_user_access_sets("heidi", "test-access-set-write", "write")
add_user_access_sets("sepp", "test-access-set-write", "write")

create_access_set("test-access-set-none", "this is a test access set")

list_user_access_sets("heidi")
list_user_access_sets("sepp")

delete_dataset("test-dataset")

vints <- as.Date(c("2025-01-01","2025-05-01","2025-10-01"))
periods <- c(1, 5, 10)
sets <- paste0("test-access-set-", c("read","read_before_release","write","none"))
for(set in sets) {
  ts_keys <- sub("test-access-set", "test-ts", set)
  for(i in 1:3) {
    # set <- sets[1]
    # i <- 1
    vint <- as.character(vints)[i]
    period <- periods[i]
    # tsl <- map(set_names(ts_keys), ~ts(1:10, end = c(data.table::year(vint), data.table::month(vint)), frequency = 12))
    tsl <- map(set_names(ts_keys), ~ts(1:12, end=c(data.table::year(vint), data.table::month(vint)), frequency = 12))
    meta_en <- map(set_names(ts_keys), ~list(title = "title", key = .x))
    meta_de <- map(set_names(ts_keys), ~list(title = "Titel", key = .x))
    meta_un <- map(set_names(ts_keys), ~list(key = .x))
    write_ts(
      tsl,
      valid_from = vint,
      access = "timeseries_access_main",
      pre_release_access = "timeseries_access_main",
      access_sets = set,
      release_topic = "globalbaro",
      release_year = 2025,
      release_period = period,
      release_time = "2025-01-10 07:00:00")
    write_ts_metadata(metadata_list = meta_en, locale = "en")
    write_ts_metadata(metadata_list = meta_de, locale = "de")
    write_ts_metadata(metadata_list = meta_un, locale = "unlocalized")
  }
}

all_keys <- c(
  read_access_set_keys("test-access-set-read_before_release"),
  read_access_set_keys("test-access-set-read"),
  read_access_set_keys("test-access-set-write"),
  read_access_set_keys("test-access-set-none"))

read_ts(all_keys, valid_on = "2025-10-01")
read_ts(all_keys, valid_on = "2025-10-01", ignore_missing = T)
read_ts(all_keys, valid_on = "2025-05-01", ignore_missing = T)
read_ts_dataset(all_keys)
read_ts_metadata(all_keys, locale = "en", ignore_missing = T)
read_ts_metadata(all_keys, locale = "de")
read_ts_metadata(all_keys, locale = "unlocalized")
read_ts_release(all_keys)
read_ts_release_future(all_keys)
read_ts_release_history(all_keys, ignore_missing = T)

read_ts_history(all_keys)

read_ts(all_keys, valid_on = "2025-10-01")
read_ts(all_keys, valid_on = "2025-10-01", ignore_missing = T)
read_ts(all_keys, valid_on = "2025-05-01", ignore_missing = T)
read_ts_dataset(all_keys, ignore_missing = T)
read_ts_metadata(all_keys, locale = "en", ignore_missing = T)
read_ts_metadata(all_keys, locale = "de", ignore_missing = T)
read_ts_metadata(all_keys, locale = "unlocalized", ignore_missing = T)
read_ts_release(all_keys, ignore_missing = T)
read_ts_update_time(all_keys, ignore_missing = T)
read_ts_release_future(all_keys, ignore_missing = T)
read_ts_release_history(all_keys, ignore_missing = T)


rename_ts(all_keys, paste0(all_keys, "-renamed"))
rename_ts(paste0(all_keys, "-renamed"), all_keys)

create_dataset("test-dataset", "this is a test dataset")
write_ts_dataset(all_keys, "test-dataset")
tsdbapi::read_dataset_keys("test-dataset")
tsdbapi::read_dataset_ts_history("test-dataset")
tsdbapi::read_dataset_ts_history("test-dataset", valid_to = "2025-12-12")
tsdbapi::read_dataset_ts_metadata("test-dataset", locale = "en")
tsdbapi::read_dataset_ts_release("test-dataset")
tsdbapi::read_dataset_ts_release_history("test-dataset")
tsdbapi::read_dataset_ts_release_future("test-dataset")
tsdbapi::read_dataset_ts_update_time("test-dataset")
tsdbapi::write_dataset_ts_release()


list_collections(owner = NULL)
delete_collection("test-collection", owner = "test-owner")
create_collection("test-collection", owner = "test-owner", description = "this is a test collection")
add_ts_to_collection("test-collection", c(all_keys, "missing"), owner = "test-owner")
add_ts_to_collection("test-collection", c(all_keys, "missing"), owner = "test-owner", ignore_missing = T)
read_collection_keys("test-collection", owner = "test-owner")
remove_ts_from_collection("test-collection", owner = "test-owner", all_keys)
read_collection_keys("test-collection", owner = "test-owner")
add_ts_to_collection("test-collection", all_keys, owner = "test-owner")
read_collection_ts("test-collection", owner = "test-owner")
read_collection_keys("test-collection", owner = "test-owner")
read_collection_ts_history("test-collection", owner = "test-owner")
read_collection_ts_history("test-collection", owner = "test-owner", valid_to = "2025-12-12")
read_collection_ts_metadata("test-collection", owner = "test-owner", locale = "unlocalized")
read_collection_ts_metadata("test-collection", owner = "test-owner", locale = "en")
read_collection_ts_metadata("test-collection", owner = "test-owner", locale = "de")
read_collection_ts_release("test-collection", owner = "test-owner")
read_collection_ts_release_history("test-collection", owner = "test-owner")
read_collection_ts_release_future("test-collection", owner = "test-owner")
read_collection_ts_update_time("test-collection", owner = "test-owner")
delete_collection("test-collection", owner = "test-owner")

list_collections(owner = NULL)
delete_collection("test-collection")
create_collection("test-collection", description = "this is a test collection")
add_ts_to_collection("test-collection", ts_keys = c(all_keys, "missing"))
add_ts_to_collection("test-collection", ts_keys = c(all_keys, "missing"), ignore_missing = T)
read_collection_keys("test-collection")
remove_ts_from_collection("test-collection", all_keys)
read_collection_keys("test-collection")
add_ts_to_collection("test-collection", all_keys)
read_collection_ts("test-collection")
read_collection_keys("test-collection")
read_collection_ts_history("test-collection")
read_collection_ts_history("test-collection", valid_to = "2025-12-12")
read_collection_ts_metadata("test-collection", locale = "unlocalized")
read_collection_ts_metadata("test-collection", locale = "en")
read_collection_ts_metadata("test-collection", locale = "de")
read_collection_ts_release("test-collection")
read_collection_ts_release_history("test-collection")
read_collection_ts_release_future("test-collection")
read_collection_ts_update_time("test-collection")
delete_collection("test-collection")

list_access_sets()
create_access_set("test-access-set", "this is a test access set")
delete_access_set("test-access-set")
list_access_sets()
create_access_set("test-access-set", "this is a test access set")
add_ts_to_access_set("test-access-set", all_keys)
read_access_set_keys("test-access-set")
remove_ts_from_access_set("test-access-set", all_keys)
read_access_set_keys("test-access-set")

devtools::load_all()
set_config(environment = "test")

list_users()
list_user_access_sets()
list_user_access_sets(username = "sepp")
add_user_access_sets("self", access_sets = "test-access-set", access_type = "read")
user_quota()

set_config(access_type = "heidi")
set_config(access_type = "sepp")

tsl <- read_ts(all_keys, valid_on = "2025-10-01", ignore_missing = T)


read_ts(all_keys)

ts(names(tsl))
ts_read(c("sepp",names(tsl)))
ts_read(c("hello",names(tsl)), ignore_missing=F)

devtools::load_all()
set_config(environment = "test")
read_ts_release(names(tsl)[1:10])
list_collections()
list_access_sets()
list_datasets()

curl localhost:8001/apis/timeseriesdb-main/plugins/de02e70e-438d-49ef-a4c1-29897963bce2
ab5966ae-d3f2-43a9-96e7-e23344eb7e36

  
dy*jB#4r

https://jpmchase.zoom.us/j/94896149035

