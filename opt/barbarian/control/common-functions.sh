function mk_log_dir() {
  mkdir -p $LOG_DIR
}

export HADOOP_CLASSPATH=$HADOOP_CLASSPATH
export HIVE_CLASSPATH=$HADOOP_CLASSPATH
