package com.itheima.controller;

import com.itheima.pojo.Result;
import com.itheima.pojo.User;
import com.itheima.service.UserService;
import com.itheima.utils.JwtUtil;
import com.itheima.utils.Md5Util;
import com.itheima.utils.ThreadLocalUtil;
import jakarta.validation.constraints.Pattern;
import org.hibernate.validator.constraints.URL;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.data.redis.core.ValueOperations;
import org.springframework.util.StringUtils;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.TimeUnit;

@RestController
@RequestMapping("/user")
@Validated
public class UserController {

    @Autowired
    private UserService userService;
    @Autowired
    private StringRedisTemplate stringRedisTemplate;

    @PostMapping("/register")
    public Result register(@Pattern(regexp = "^\\S{5,16}$") String username, @Pattern(regexp = "^\\S{5,16}$") String password) {

        //鏌ヨ鐢ㄦ埛
        User u = userService.findByUserName(username);
        if (u == null) {
            //娌℃湁鍗犵敤
            //娉ㄥ唽
            userService.register(username, password);
            return Result.success();
        } else {
            //鍗犵敤
            return Result.error("鐢ㄦ埛鍚嶅凡琚崰鐢?");
        }
    }

    @PostMapping("/login")
    public Result<String> login(@Pattern(regexp = "^\\S{5,16}$") String username, @Pattern(regexp = "^\\S{5,16}$") String password) {
        //鏍规嵁鐢ㄦ埛鍚嶆煡璇㈢敤鎴?
        User loginUser = userService.findByUserName(username);
        //鍒ゆ柇璇ョ敤鎴锋槸鍚﹀瓨鍦?
        if (loginUser == null) {
            return Result.error("鐢ㄦ埛鍚嶉敊璇?");
        }

        //鍒ゆ柇瀵嗙爜鏄惁姝ｇ‘  loginUser瀵硅薄涓殑password鏄瘑鏂?
        if (Md5Util.getMD5String(password).equals(loginUser.getPassword())) {
            //鐧诲綍鎴愬姛
            Map<String, Object> claims = new HashMap<>();
            claims.put("id", loginUser.getId());
            claims.put("username", loginUser.getUsername());
            String token = JwtUtil.genToken(claims);
            //鎶妕oken瀛樺偍鍒皉edis涓?
            ValueOperations<String, String> operations = stringRedisTemplate.opsForValue();
            operations.set(token, token, 1, TimeUnit.HOURS);
            return Result.success(token);
        }
        return Result.error("瀵嗙爜閿欒");
    }

    @GetMapping("/userInfo")
    public Result<User> userInfo(/*@RequestHeader(name = "Authorization") String token*/) {
        //鏍规嵁鐢ㄦ埛鍚嶆煡璇㈢敤鎴?
       /* Map<String, Object> map = JwtUtil.parseToken(token);
        String username = (String) map.get("username");*/
        Map<String, Object> map = ThreadLocalUtil.get();
        String username = (String) map.get("username");
        User user = userService.findByUserName(username);
        return Result.success(user);
    }

    @PutMapping("/update")
    public Result update(@RequestBody @Validated User user) {
        userService.update(user);
        return Result.success();
    }

    @PatchMapping("updateAvatar")
    public Result updateAvatar(@RequestParam @URL String avatarUrl) {
        userService.updateAvatar(avatarUrl);
        return Result.success();
    }

    @PatchMapping("/updatePwd")
    public Result updatePwd(@RequestBody Map<String, String> params,@RequestHeader("Authorization") String token) {
        //1.鏍￠獙鍙傛暟
        String oldPwd = params.get("old_pwd");
        String newPwd = params.get("new_pwd");
        String rePwd = params.get("re_pwd");

        if (!StringUtils.hasLength(oldPwd) || !StringUtils.hasLength(newPwd) || !StringUtils.hasLength(rePwd)) {
            return Result.error("缂哄皯蹇呰鐨勫弬鏁?");
        }

        //鍘熷瘑鐮佹槸鍚︽纭?
        //璋冪敤userService鏍规嵁鐢ㄦ埛鍚嶆嬁鍒板師瀵嗙爜,鍐嶅拰old_pwd姣斿
        Map<String,Object> map = ThreadLocalUtil.get();
        String username = (String) map.get("username");
        User loginUser = userService.findByUserName(username);
        if (!loginUser.getPassword().equals(Md5Util.getMD5String(oldPwd))){
            return Result.error("鍘熷瘑鐮佸～鍐欎笉姝ｇ‘");
        }

        //newPwd鍜宺ePwd鏄惁涓€鏍?
        if (!rePwd.equals(newPwd)){
            return Result.error("涓ゆ濉啓鐨勬柊瀵嗙爜涓嶄竴鏍?");
        }

        //2.璋冪敤service瀹屾垚瀵嗙爜鏇存柊
        userService.updatePwd(newPwd);
        //鍒犻櫎redis涓搴旂殑token
        ValueOperations<String, String> operations = stringRedisTemplate.opsForValue();
        operations.getOperations().delete(token);
        return Result.success();
    }
}
