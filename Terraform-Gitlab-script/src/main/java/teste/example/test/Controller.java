package teste.example.test;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class Controller {

    @GetMapping("/")
    String helloWorld(){
        return "hello World. This is testing Spring boot application";
    }
}
