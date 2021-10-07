package entities;

import lombok.Data;

import javax.persistence.Entity;
import javax.persistence.Id;

@Entity
@Data
public class Cash {

    @Id
    private int cash_id;

    private int allCashIn;
    private int allCashOut;


}
