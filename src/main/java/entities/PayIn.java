package entities;

import lombok.Data;

import javax.persistence.*;
import java.time.LocalDateTime;


@Entity
@Data
public class PayIn {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int payIn_id;

    private String cName;
    private int receipt_id;
    private int payIn_amount;
    private String payment_detail;
    private LocalDateTime payIn_date;



}
