// Freely adapted from
// https://github.com/savoirfairelinux/ansible-nexus3-oss/blob/master/files/groovy/create_task.groovy
import org.sonatype.nexus.scheduling.TaskConfiguration;
import org.sonatype.nexus.scheduling.TaskInfo;
import org.sonatype.nexus.scheduling.TaskScheduler;
import org.sonatype.nexus.scheduling.schedule.Schedule;

import groovy.json.JsonSlurper;

def params = new JsonSlurper().parseText(args);

TaskScheduler taskScheduler = container.lookup(TaskScheduler.class.getName());
TaskInfo existingTask = taskScheduler.listsTasks().find { TaskInfo taskInfo ->
    taskInfo.getName() == params.name;
}
if (existingTask && !existingTask.remove()) {
    throw new RuntimeException("Could not remove currently running task: " + params.name);
}

TaskConfiguration taskConfiguration = taskScheduler.createTaskConfigurationInstance(params.typeId);
taskConfiguration.setName(params.name);

params.taskProperties.each { key, value -> taskConfiguration.setString(key, value) };

Schedule schedule = taskScheduler.scheduleFactory.cron(new Date(), params.crontab);

taskScheduler.scheduleTask(taskConfiguration, schedule);
