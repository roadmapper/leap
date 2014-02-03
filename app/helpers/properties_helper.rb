module PropertiesHelper
    
    def start_date(to_date)
        (to_date - 1.years + 1.months).beginning_of_month
    end
    
    def end_date(to_date)
        (to_date + 1.years + 1.months).end_of_month
    end
    
    def get_records(record_lookup, start_date, end_date)
        Recording.where("read_date >= :start_date AND read_date <= :end_date AND acctnum = :acct_num", {start_date: @startdate, end_date: @enddate, acct_num: record_lookup.acct_num}).order("read_date ASC")
    end
    
    def gap_months(start_date)
        start = start_date - 1.months
        months = Array.new
        for i in 0..23
            months.push(start + i.months)
        end
        months
    end
    
    def get_data(records)
        
    end
    
end
