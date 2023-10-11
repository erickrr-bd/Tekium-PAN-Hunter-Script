package main

import (
    "fmt"
    "os"
    "flag"
    "io/ioutil"
    "log"
    "regexp"
)

func main() {
    path_search := flag.String("path_search", "C:\\", "PAN's search path")
    filters := flag.String("filters", "*.csv", "Search filters")
    fmt.Println("-------------------------------------------------------------------------------")
    fmt.Println("Copyright©Tekium 2023. All rights reserved.")
    fmt.Println("Author: Erick Roberto Rodriguez Rodriguez")
    fmt.Println("Email: erodriguez@tekium.mx, erickrr.tbd93@gmail.com")
    fmt.Println("GitHub: https://github.com/erickrr-bd/Tekium-PAN-Hunter-Script")
    fmt.Println("Tekium PAN Hunter Script v1.1.2 - September 2023")
    fmt.Println("-------------------------------------------------------------------------------")
    hostname, error := os.Hostname()
    if error != nil {
        fmt.Println(error)
        os.Exit(1)
    }
    flag.Parse()
    fmt.Println("Hostname:", hostname)
    fmt.Println("Path:", *path_search)
    fmt.Println("Filters:", *filters)
    
    //regex_amex := "([^0-9-]|^)(3(4[0-9]{2}|7[0-9]{2})( |-|)[0-9]{6}( |-|)[0-9]{5})([^0-9-]|$)"
    regex_visa := "([^0-9-]|^)(4[0-9]{3}( |-|)([0-9]{4})( |-|)([0-9]{4})( |-|)([0-9]{4}))([^0-9-]|$)"
    //regex_master := "([^0-9-]|^)(5[0-9]{3}( |-|)([0-9]{4})( |-|)([0-9]{4})( |-|)([0-9]{4}))([^0-9-]|$)"

    file, err := ioutil.ReadFile("/home/erodriguez/Documentos/Projects/prueba.txt")
    if err != nil{
        log.Fatal(err)
    }

    boolean, err := regexp.Match(regex_visa, file)
    if err != nil{
        log.Fatal(err)
    }
    fmt.Println(boolean)

    visa := regexp.MustCompile("([^0-9-]|^)(4[0-9]{3}( |-|)([0-9]{4})( |-|)([0-9]{4})( |-|)([0-9]{4}))([^0-9-]|$)")
    allSubstringMatches := visa.FindAllString(file, -1)

    //pattern := regexp.MustCompile("H[a-z]{4}|[A-z]ork")
    //welcomeMessage := "Hello guys, welcome to new york city"
    //allSubstringMatches := pattern.FindAllString(welcomeMessage, -1)
    fmt.Println(allSubstringMatches)



    //func IsExist(str, filepath string) bool {
    //  b, err := ioutil.ReadFile(filepath)
    //  if err != nil {
    //          panic(err)
    //  }

    //  isExist, err := regexp.Match(str, b)
    //  if err != nil {
    //          panic(err)
    //  }
    //  return isExist
    //}
    //archivos, err := ioutil.ReadDir(path_search)
    //if err != nil {
    //    log.Fatal(err)
    //}
    //for _, archivo := range archivos {
    //   fmt.Println("Nombre:", archivo.Name())
    //    fmt.Println("Tamaño:", archivo.Size())
    //    fmt.Println("Modo:", archivo.Mode())
    //    fmt.Println("Ultima modificación:", archivo.ModTime())
    //    fmt.Println("Es directorio?:", archivo.IsDir())
    //    fmt.Println("-----------------------------------------")
    //}
}