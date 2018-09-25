require 'csv'
require 'pry'

def convertToT (array)
  array.map! { |letter|
    if letter == "U"
      letter = "T"
    else
      letter = letter
    end
  }
end

files = Dir["*.phy"]
# filepath = 'test.phy'

files.each do |filepath|
  especieCadenaArray = []
  control = []
  temp = []
  tempN = []
  ordenColumnas = Array.new(513) {Array.new(4,0)}

  #Guarda cada línea del texto en un array y los separa entre título y cadena de nucleótidos
  File.readlines(filepath).each do |line|
    especieCadenaArray << line.split(' ')
  end

  #Guarda cadena de control y divide cada letra en una posíción del array
  control = especieCadenaArray[0][1].split(//)
  control = convertToT (control)

  especieCadenaArray.each do |array|  #itero dentro de todo el array de arrays

    temp = array[1].split(//) #dividido cada cadena con el split y lo guardo en temp
    temp = convertToT (temp)
    headers = ['Especie']
    x = 0
    tempN << array[0]
    temp.each do |letter|     #itero dentro de temp para comparar con el control
      headers << "Posición" + (x+1).to_s
      if ordenColumnas[x].include? (letter)
        if letter == control[x]
          tempN << 0
        elsif letter == "-"
          tempN << "-"
        else
          tempN << ordenColumnas[x].index(letter) - 4
        end
      else
        ordenColumnas[x] << letter
        if letter == control[x]
          tempN << 0
        elsif letter == "-"
          tempN << "-"
        else
          tempN << ordenColumnas[x].index(letter) - 4
        end
      end
      tempN.length()
      x = x + 1
    end
    # puts array[0] #Nombre especie
    # p tempN #Cadena 0y1s

    CSV.open("#{filepath}.csv", "a+", :headers => true) do |csv|
      csv << headers if csv.count.eql? 0
      csv << tempN
    end
    # puts tempN.length() #Largo de la cadena
    tempN = []
   # puts "************************************"
 end
end

