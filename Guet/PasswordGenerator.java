import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

public class PasswordGenerator {
    public static void main(String[] args) {
        BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
        
        // 生成 123456 的哈希
        String password = "123456";
        String hash = encoder.encode(password);
        
        System.out.println("原始密码: " + password);
        System.out.println("BCrypt哈希: " + hash);
        System.out.println();
        System.out.println("SQL更新语句:");
        System.out.println("UPDATE guet_user SET password = '" + hash + "' WHERE username = 'zhangsan';");
        
        // 验证数据库中的哈希
        String dbHash = "$2a$10$EBAjGQz4zfn8SiX1WF4G6upRfWOqJ8w9xIEpTpYPO//SmM4pWiagy";
        System.out.println();
        System.out.println("验证数据库密码:");
        System.out.println("123456 匹配结果: " + encoder.matches("123456", dbHash));
        System.out.println("admin 匹配结果: " + encoder.matches("admin", dbHash));
        System.out.println("zhangsan 匹配结果: " + encoder.matches("zhangsan", dbHash));
    }
}
