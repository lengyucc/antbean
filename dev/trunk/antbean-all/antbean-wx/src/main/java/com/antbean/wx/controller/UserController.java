package com.antbean.wx.controller;

import org.antbean.biz.UserService;

import com.antbean.dal.model.User;
import com.jfinal.core.Controller;
import com.jfinal.plugin.activerecord.Page;

public class UserController extends Controller {

	public void index() {
		Page<User> userPage = UserService.service.paginate(1, 10);
		renderJson(userPage);
	}

}
