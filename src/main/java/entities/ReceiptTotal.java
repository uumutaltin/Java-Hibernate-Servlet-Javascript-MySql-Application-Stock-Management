package entities;

import lombok.Data;

import javax.persistence.Entity;
import javax.persistence.Id;

@Entity
@Data
public class ReceiptTotal {


    @Id
    private int receipt_id;
    private int join_receipt;
    private int join_receipt_total;
    private int receipt_payment;


}
