package entities;

import lombok.Data;

import javax.persistence.Entity;
import javax.persistence.Id;
import java.time.LocalDateTime;

@Entity
@Data
public class PayInTable {


    @Id
    private int receipt_id;
    private int cu_id;
    private String cu_name;
    private String cu_surname;
    private int receipt_total;
    private int payIn_amount;
    private LocalDateTime payIn_date;
    private String payment_detail;
    private long box_receipt;
}
