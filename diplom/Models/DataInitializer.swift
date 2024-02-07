//
//  DataInitializer.swift
//  diplom
//
//  Created by Dulin Gleb on 15.1.24..
//

import Foundation
import RealmSwift

class DataInitializer {
    static func initializeDataIfNeeded() {

        // Проверяем, были ли данные уже добавлены
        let isDataInitialized = UserDefaults.standard.bool(forKey: "DataInitialized")

        if isDataInitialized { return }
        
        let currenciesData: [(String, String, String)] = [
            ("AED", "United Arab Emirates Dirham", "د.إ"),
            ("AFN", "Afghan Afghani", "؋"),
            ("ALL", "Albanian Lek", "L"),
            ("AMD", "Armenian Dram", "֏"),
            ("ANG", "Netherlands Antillean Guilder", "ƒ"),
            ("AOA", "Angolan Kwanza", "Kz"),
            ("ARS", "Argentine Peso", "$"),
            ("AUD", "Australian Dollar", "$"),
            ("AWG", "Aruban Florin", "ƒ"),
            ("AZN", "Azerbaijani Manat", "₼"),
            ("BAM", "Bosnia-Herzegovina Convertible Mark", "KM"),
            ("BBD", "Barbadian Dollar", "$"),
            ("BDT", "Bangladeshi Taka", "৳"),
            ("BGN", "Bulgarian Lev", "лв"),
            ("BHD", "Bahraini Dinar", ".د.ب"),
            ("BIF", "Burundian Franc", "FBu"),
            ("BMD", "Bermudian Dollar", "$"),
            ("BND", "Brunei Dollar", "$"),
            ("BOB", "Bolivian Boliviano", "Bs."),
            ("BRL", "Brazilian Real", "R$"),
            ("BSD", "Bahamian Dollar", "$"),
            ("BTN", "Bhutanese Ngultrum", "Nu."),
            ("BWP", "Botswanan Pula", "P"),
            ("BYN", "Belarusian Ruble", "Br"),
            ("BZD", "Belize Dollar", "BZ$"),
            ("CAD", "Canadian Dollar", "$"),
            ("CDF", "Congolese Franc", "FC"),
            ("CHF", "Swiss Franc", "CHF"),
            ("CLP", "Chilean Peso", "$"),
            ("CNY", "Chinese Yuan", "¥"),
            ("COP", "Colombian Peso", "$"),
            ("CRC", "Costa Rican Colón", "₡"),
            ("CUP", "Cuban Peso", "₱"),
            ("CVE", "Cape Verdean Escudo", "$"),
            ("CZK", "Czech Republic Koruna", "Kč"),
            ("DJF", "Djiboutian Franc", "Fdj"),
            ("DKK", "Danish Krone", "kr"),
            ("DOP", "Dominican Peso", "RD$"),
            ("DZD", "Algerian Dinar", "د.ج"),
            ("EGP", "Egyptian Pound", "£"),
            ("ERN", "Eritrean Nakfa", "Nfk"),
            ("ETB", "Ethiopian Birr", "Br"),
            ("EUR", "Euro", "€"),
            ("FJD", "Fijian Dollar", "$"),
            ("FKP", "Falkland Islands Pound", "£"),
            ("FOK", "Faroese Króna", "kr"),
            ("GBP", "British Pound Sterling", "£"),
            ("GEL", "Georgian Lari", "₾"),
            ("GGP", "Guernsey Pound", "£"),
            ("GHS", "Ghanaian Cedi", "₵"),
            ("GIP", "Gibraltar Pound", "£"),
            ("GMD", "Gambian Dalasi", "D"),
            ("GNF", "Guinean Franc", "FG"),
            ("GTQ", "Guatemalan Quetzal", "Q"),
            ("GYD", "Guyanaese Dollar", "$"),
            ("HKD", "Hong Kong Dollar", "$"),
            ("HNL", "Honduran Lempira", "L"),
            ("HRK", "Croatian Kuna", "kn"),
            ("HTG", "Haitian Gourde", "G"),
            ("HUF", "Hungarian Forint", "Ft"),
            ("IDR", "Indonesian Rupiah", "Rp"),
            ("ILS", "Israeli New Sheqel", "₪"),
            ("IMP", "Isle of Man Pound", "£"),
            ("INR", "Indian Rupee", "₹"),
            ("IQD", "Iraqi Dinar", "ع.د"),
            ("IRR", "Iranian Rial", "﷼"),
            ("ISK", "Icelandic Króna", "kr"),
            ("JEP", "Jersey Pound", "£"),
            ("JMD", "Jamaican Dollar", "J$"),
            ("JOD", "Jordanian Dinar", "JD"),
            ("JPY", "Japanese Yen", "¥"),
            ("KES", "Kenyan Shilling", "KSh"),
            ("KGS", "Kyrgystani Som", "с"),
            ("KHR", "Cambodian Riel", "៛"),
            ("KID", "Kiribati Dollar", "$"),
            ("KMF", "Comorian Franc", "CF"),
            ("KRW", "South Korean Won", "₩"),
            ("KWD", "Kuwaiti Dinar", "د.ك"),
            ("KYD", "Cayman Islands Dollar", "$"),
            ("KZT", "Kazakhstani Tenge", "₸"),
            ("LAK", "Laotian Kip", "₭"),
            ("LBP", "Lebanese Pound", "£"),
            ("LKR", "Sri Lankan Rupee", "Rs"),
            ("LRD", "Liberian Dollar", "$"),
            ("LSL", "Lesotho Loti", "L"),
            ("LYD", "Libyan Dinar", "LD"),
            ("MAD", "Moroccan Dirham", "د.م."),
            ("MDL", "Moldovan Leu", "L"),
            ("MGA", "Malagasy Ariary", "Ar"),
            ("MKD", "Macedonian Denar", "ден"),
            ("MMK", "Myanmar Kyat", "K"),
            ("MNT", "Mongolian Tugrik", "₮"),
            ("MOP", "Macanese Pataca", "P"),
            ("MRU", "Mauritanian Ouguiya", "UM"),
            ("MUR", "Mauritian Rupee", "₨"),
            ("MVR", "Maldivian Rufiyaa", "Rf"),
            ("MWK", "Malawian Kwacha", "MK"),
            ("MXN", "Mexican Peso", "$"),
            ("MYR", "Malaysian Ringgit", "RM"),
            ("MZN", "Mozambican Metical", "MT"),
            ("NAD", "Namibian Dollar", "$"),
            ("NGN", "Nigerian Naira", "₦"),
            ("NIO", "Nicaraguan Córdoba", "C$"),
            ("NOK", "Norwegian Krone", "kr"),
            ("NPR", "Nepalese Rupee", "Rs"),
            ("NZD", "New Zealand Dollar", "$"),
            ("OMR", "Omani Rial", "ر.ع."),
            ("PAB", "Panamanian Balboa", "B/."),
            ("PEN", "Peruvian Nuevo Sol", "S/"),
            ("PGK", "Papua New Guinean Kina", "K"),
            ("PHP", "Philippine Peso", "₱"),
            ("PKR", "Pakistani Rupee", "₨"),
            ("PLN", "Polish Złoty", "zł"),
            ("PYG", "Paraguayan Guarani", "₲"),
            ("QAR", "Qatari Rial", "ر.ق"),
            ("RON", "Romanian Leu", "lei"),
            ("RSD", "Serbian Dinar", "дин."),
            ("RUB", "Russian Ruble", "₽"),
            ("RWF", "Rwandan Franc", "FRw"),
            ("SAR", "Saudi Riyal", "ر.س"),
            ("SBD", "Solomon Islands Dollar", "$"),
            ("SCR", "Seychellois Rupee", "₨"),
            ("SDG", "Sudanese Pound", "ج.س."),
            ("SEK", "Swedish Krona", "kr"),
            ("SGD", "Singapore Dollar", "$"),
            ("SHP", "Saint Helena Pound", "£"),
            ("SLL", "Sierra Leonean Leone", "Le"),
            ("SOS", "Somali Shilling", "Sh"),
            ("SRD", "Surinamese Dollar", "$"),
            ("SSP", "South Sudanese Pound", "£"),
            ("STN", "São Tomé and Príncipe Dobra", "Db"),
            ("SYP", "Syrian Pound", "£S"),
            ("SZL", "Swazi Lilangeni", "L"),
            ("THB", "Thai Baht", "฿"),
            ("TJS", "Tajikistani Somoni", "ЅМ"),
            ("TMT", "Turkmenistani Manat", "T"),
            ("TND", "Tunisian Dinar", "د.ت"),
            ("TOP", "Tongan Pa'anga", "T$"),
            ("TRY", "Turkish Lira", "₺"),
            ("TTD", "Trinidad and Tobago Dollar", "TT$"),
            ("TVD", "Tuvaluan Dollar", "$"),
            ("TWD", "New Taiwan Dollar", "NT$"),
            ("TZS", "Tanzanian Shilling", "Sh"),
            ("UAH", "Ukrainian Hryvnia", "₴"),
            ("UGX", "Ugandan Shilling", "UGX"),
            ("USD", "United States Dollar", "$"),
            ("UYU", "Uruguayan Peso", "$"),
            ("UZS", "Uzbekistan Som", "so'm"),
            ("VES", "Venezuelan Bolívar", "Bs."),
            ("VND", "Vietnamese Đồng", "₫"),
            ("VUV", "Vanuatu Vatu", "VT"),
            ("WST", "Samoan Tala", "T"),
            ("XAF", "Central African CFA Franc", "FCFA"),
            ("XCD", "Eastern Caribbean Dollar", "$"),
            ("XDR", "Special Drawing Rights", "XDR"),
            ("XOF", "West African CFA Franc", "CFA"),
            ("XPF", "CFP Franc", "₣"),
            ("YER", "Yemeni Rial", "﷼"),
            ("ZAR", "South African Rand", "R"),
            ("ZMW", "Zambian Kwacha", "ZK"),
            ("ZWL", "Zimbabwean Dollar", "$")
        ]
        
        for currencyData in currenciesData {
            let newCurrency = Currency()
            newCurrency.code = currencyData.0
            newCurrency.name = currencyData.1
            newCurrency.symbol = currencyData.2

            StorageManager.shared.addCurrency(newCurrency)
        }
        
        let newAccount = Account()
        newAccount.name = "Cashe"
        newAccount.balance = 0
        newAccount.currency = StorageManager.shared.getCurrencies().filter("code == %@", "USD").first
        
        StorageManager.shared.addAccount(newAccount)
        
        let transactionCategories: [(String, String, String)] = [
            ("Entertainment", "Popcorn", "FF9500"),
            ("Food", "ShoppingCartSimple", "AF52DE"),
            ("Health", "FirstAid", "34C759"),
            ("Hygiene", "Bathtub", "32BEFE"),
            ("Bills", "Receipt", "000000"),
            ("Home", "HouseLine", "0040DD"),
            ("Transport", "Train", "FF2D55"),
            ("Sport", "Barbell", "8E8E93")
        ]
        
        var pos = 1
        for transactionCategory in transactionCategories {
            let newTransactionCategory = TransactionCategory()
            newTransactionCategory.name = transactionCategory.0
            newTransactionCategory.iconName = transactionCategory.1
            newTransactionCategory.iconColor = transactionCategory.2
            newTransactionCategory.pos = pos
            pos += 1
            
            StorageManager.shared.addTransactionCategory(category: newTransactionCategory)
        }
        
        let incomeTransactionCategories: [(String, String, String)] = [
            ("Salary", "briefcase", "5856D6")
        ]
        
        for incomeTransactionCategory in incomeTransactionCategories {
            let newIncomeTransactionCategory = TransactionCategory()
            newIncomeTransactionCategory.name = incomeTransactionCategory.0
            newIncomeTransactionCategory.iconName = incomeTransactionCategory.1
            newIncomeTransactionCategory.iconColor = incomeTransactionCategory.2
            newIncomeTransactionCategory.type = TransactionType.income.rawValue
            
            StorageManager.shared.addTransactionCategory(category: newIncomeTransactionCategory)
            

            // Устанавливаем флаг, что данные были добавлены
            UserDefaults.standard.set(true, forKey: "DataInitialized")
        }
    }
}
