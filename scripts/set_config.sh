#!/bin/bash
#Sets the configuration files for hadoop 2.x
  
#by default script will run for master
TYPE=master
USER=naman
 
if [ -n "$1" ]
then
TYPE=$1
fi
 
#Global Variables
HOME_DIR=/home/${USER}
HADOOP_HOME=${HOME_DIR}/hadoop-2.2.0
NAMENODE=master
NAMENODE_PORT=9000
 
SLAVES=(slave1 slave2)
 
 
REPLICATION_FACTOR=1
NAMENODE_DIR=${HADOOP_HOME}/yarn_data/hdfs/namenode
DATANODE_DIR=${HADOOP_HOME}/yarn_data/hdfs/datanode
 
 
RESOURCE_TRACKER_PORT=8025
SCHEDULER_PORT=8030
RESOURCE_MANAGER_PORT=8040
LOCALIZER_PORT=8060
 
 
  
#Change to the Config Directory
cd ${HADOOP_HOME}/etc/hadoop
 
 
#Set the common config
  
#################################Core-Site.xml##########################
  
sed -i "20i<property>\n\
<name>fs.defaultFS</name>\n\
<value>hdfs://${NAMENODE}:${NAMENODE_PORT}</value>\n\
</property>" core-site.xml
 
echo "Core-Site Edited"
  
################################Hdfs-Site.xml###########################
 
sed -i "20i<property>\n\
<name>dfs.replication</name>\n\
<value>${REPLICATION_FACTOR}</value>\n\
</property>\n\
<property>\n\
<name>dfs.namenode.name.dir</name>\n\
<value>file:${NAMENODE_DIR}</value>\n\
</property>\n\
<property>\n\
<name>dfs.datanode.data.dir</name>\n\
<value>file:${DATANODE_DIR}</value>\n\
</property>" hdfs-site.xml
 
echo "HDFS-Site Edited"
 
##############################Mapred-Site.xml###############################
 
echo '<property>
<name>mapreduce.framework.name</name>
<value>yarn</value>
</property>' >> mapred-site.xml
 
echo "Mapred Site Created"
 
#############################yarn-site.xml##################################
 
sed -i "18i<property>\n\
<name>yarn.nodemanager.aux-services</name>\n\
<value>mapreduce_shuffle</value>\n\
</property>\n\
<property>\n\
<name>yarn.nodemanager.aux-services.mapreduce.shuffle.class</name>\n\
<value>org.apache.hadoop.mapred.ShuffleHandler</value>\n\
</property>\n\
<property>\n\
  <name>yarn.resourcemanager.resource-tracker.address</name>\n\
  <value>${NAMENODE}:${RESOURCE_TRACKER_PORT}</value>\n\
</property>\n\
<property>\n\
  <name>yarn.resourcemanager.scheduler.address</name>\n\
  <value>${NAMENODE}:${SCHEDULER_PORT}</value>\n\
</property>\n\
<property>\n\
  <name>yarn.resourcemanager.address</name>\n\
  <value>${NAMENODE}:${RESOURCE_MANAGER_PORT}</value>\n\
</property>" yarn-site.xml
 
echo "Yarn Site Edited"
 
 
#If Master Node then add this
if [ ${TYPE}=="master" ]
then
 
sed -i "38i<property>\n\
<name>yarn.nodemanager.localizer.address</name>\n\
<value>${NAMENODE}:${LOCALIZER_PORT}</value>\n\
</property>" yarn-site.xml
 
 
########Only if master####################################################
 
rm -f slaves
 
for i in ${SLAVES[@]}
do
 
echo $i >> slaves
 
done
 
fi
 
echo "Slaves file Done"
 
echo "Making Namenode Directory"
mkdir -p NAMENODE_DIR
 
echo "Making Datanode Directory"
mkdir -p DATANODE_DIR
 
 
echo "Setting Path variables"
 
echo "export HADOOP_HOME=${HADOOP_HOME}" >> .bashrc
echo "export HADOOP_HOME=${HADOOP_HOME}" >> .bash_profile
 
echo "export PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin" >> .bashrc
echo "export PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin" >> .bash_profile
 
export PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin
