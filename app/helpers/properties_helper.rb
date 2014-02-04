module PropertiesHelper
    
    def start_date(to_date)
        #Counting month of the TO date as pre or post.
        #Start data retrieval on the 20th of the month to ensure capturing all relevant data.
        
        if(to_date.day < 15)
            (to_date - 1.years).beginning_of_month + 14.days
        else
            (to_date - 1.years + 1.month).beginning_of_month + 14.days
        end
        
    end
    
    def end_date(to_date)
        #End data retrieval on the 20th of the month to ensure capturing all relevant data.
        if(to_date.day < 15)
            (to_date + 1.years).beginning_of_month + 19.days
            else
            (to_date + 1.years + 1.month).beginning_of_month + 19.days
        end
    end
    
    def get_records(record_lookup, start_date, end_date)
        Recording.where("read_date >= :start_date AND read_date <= :end_date AND acctnum = :acct_num", {start_date: @startdate, end_date: @enddate, acct_num: record_lookup.acct_num}).order("read_date ASC")
    end
    
    def gap_months(start_date)
        months = Array.new
        for i in 0..23
            months.push(start_date + i.months)
        end
        months
    end
    
    def get_data(records, startdate)
        
        data = Array.new
        
        if(records.length == 24)
            records.each do |rec|
                data.push(rec.consumption);
            end
        else
            count = 0
            records.each do |rec|
                read_date = rec.read_date
                days_in_month = rec.days_in_month
                for i in count..23
                    currdate = startdate + i.months
                    if((currdate >= read_date - days_in_month.days) && (currdate <= read_date.end_of_month))
                        data.push(rec.consumption)
                        count += 1;
                        break
                    else
                        data.push("---");
                        count += 1;
                    end
                end
            end
        end
        
        while(data.length < 24) do
            data.push("---");
        end
        
        data
    end
    
end
