package org.antbean.biz;

import com.antbean.dal.model.User;
import com.jfinal.plugin.activerecord.Page;

public class UserService {

	public static final UserService service = new UserService();

	public Page<User> paginate(int pageNumber, int pageSize) {
		return User.dao.paginate(pageNumber, pageSize);
	}
}
