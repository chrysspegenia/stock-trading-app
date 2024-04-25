module ApplicationHelper

    def format_decimal_with_commas(number)
        number_with_delimeter(number, delimeter: ",", separator: ".")
    end

end
