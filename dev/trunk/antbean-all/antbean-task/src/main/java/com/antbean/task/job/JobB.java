package com.antbean.task.job;

import org.apache.commons.lang3.time.DateFormatUtils;
import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

public class JobB implements Job {

	@Override
	public void execute(JobExecutionContext context) throws JobExecutionException {
		System.out.println(DateFormatUtils.format(System.currentTimeMillis(), "HH:mm:ss") + ", job B running...");
	}

}
