require 'compare_file/version'

module CompareFile
  class Compare

    def initialize(file, sec_file)
      @file  = file
      @sec_file = sec_file
    end

    def comparefiles
      first  = load(@file)
      second = load(@sec_file)
      lines = []
      different = first | second
      same = first & second
      different.each_with_index do | val, i |
        if (same.include? first[i])
          val1 = first[i]
          val2 = first[i]
        else
          val1 = (same.include? first[i])  ? nil : first[i]
          val2 = (same.include? second[i]) ? nil : second[i]
        end
        lines << [val1, val2] unless val1.nil? && val2.nil?
      end
      conclusion(result(lines))
    end

    private

    def load(file_path)
      unless file_path.empty?
        return File.readlines(file_path).each { |line| line.delete!("\n") }
      else
        raise 'File not found! Try again please.'
      end
    end

    def result(lines)
      line  = []
      lines.each_with_index do | val, i |
        line << i + 1
        if val[0] == val[1]
          line << ' '
          line << val[0]
        elsif val[0].nil?
          line << '+'
          line << val[1]
        elsif val[1].nil?
          line << '-'
          line << val[0]
        elsif val[0] != val[1]
          line << '*'
          line << "#{ val[0] } | #{ val[1] }"
        end
      end
      return line
    end

    def conclusion(res)
      res.each_with_index do | val, i |
        if ((i + 1) % 3 == 0) 
          print "#{ val }\n" 
        else
          print "#{ val } "
        end
      end
    end
  end
end
