package com.kaze.pet.utils;

import com.kaze.pet.entity.User;

/**
 * @author Kaze
 */
public class UserContext {
    private static final ThreadLocal<User> THREAD_LOCAL = new ThreadLocal<User>();

    public static void setUser(User user) {
        THREAD_LOCAL.set(user);
    }

    public static User getUser() {
        return THREAD_LOCAL.get();

    }
    // 请求结束时清除，否则会导致内存泄漏
    public static void removeUser() {
        THREAD_LOCAL.remove();
    }
}
