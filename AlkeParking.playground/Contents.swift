//
// Authors: Daniel e Lili
//

import Foundation

enum VehicleType {
    case car
    case moto
    case miniBus
    case bus
}

protocol Parkable {
    var plate: String { get set }
    var type: VehicleType { get }
    var checkInTime: Date { get }
    var discountCard: String? { get set }
}

struct Parking {
    var vehicles = Set<Vehicle>()
    let full: Int = 20
    var aviability = (0, 0)
    
    mutating func checkInVehicle(_ vehicle: Vehicle, onFinish: (Bool) -> Void) {
        // Insert vehicle here
       // let approved = vehicles.count < full
        guard vehicles.count < full else {
            print("Sorry, the check-in failed")
            print("the parking is full")
            return onFinish(false)
        }
        for car in vehicles {
            if car.plate == vehicle.plate {
                print("Sorry, the check-in failed")
                print("the vehicle \(vehicle.plate) is already checked")
                return onFinish(false)
            }
        }
        vehicles.insert(vehicle)
        print("Welcome to AlkeParking!")
        return onFinish(true)
    }
    
    mutating func calculateFee(_ type: VehicleType, _ parkedTime: Int?, hasDiscountCard: String?)->Int{
        var fee: Int
        switch type {
        case .bus:
            fee = 30
        case .miniBus:
            fee = 25
        case .moto:
            fee = 15
        case .car:
            fee = 20
        }
        
        guard let parkedTime = parkedTime else { return 0}
        
        if parkedTime > 120 {
            let coupleHours = parkedTime-120
            let checkRound = coupleHours / 15
            if coupleHours % 15 != 0 {
                fee = fee + ((checkRound + 1)*5)
            } else {
                fee = fee + (checkRound*5)
            }
        }
        
        guard let hasDiscountCard = hasDiscountCard else {return fee}
        let discountFee = Int(Double(fee) * 0.85)
        
        return discountFee
    }
    
    mutating func checkOutVehicle(plate: String, onSuccess: (Int) -> Void, onError: () -> Void) {
        for vehicle in vehicles {
            var variableVehicle = vehicle
            if variableVehicle.plate == plate {
                let fee = calculateFee(variableVehicle.type, variableVehicle.parkedTime, hasDiscountCard: variableVehicle.discountCard)
                onSuccess(fee)
                vehicles.remove(vehicle)
                aviability.0 += 1
                aviability.1 += fee
            } else {
                onError()
            }
        }
    }
    
    func showEarnings(){
        print("\(aviability.0) vehicles have checked out and have earnings of $\(aviability.1)")
    }
    
    func listVehicles(){
        for vehicle in vehicles {
            print("plate: \(vehicle.plate)")
        }
    }
    
}

struct Vehicle: Hashable, Parkable {
    var plate: String
    let type: VehicleType
    var checkInTime: Date
    var discountCard: String?

    
    lazy var parkedTime: Int? = {
        let mins = Calendar.current.dateComponents([.minute], from: self.checkInTime, to: Date()).minute ?? 0
        return mins
    }()
    
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(plate)
    }

    static func ==(lhs: Vehicle, rhs: Vehicle)-> Bool {
        return lhs.plate == rhs.plate
    }
    
    
    
}

var alkeParking = Parking()


let vehicle1 = Vehicle(plate: "1", type: VehicleType.car, checkInTime: Date(), discountCard: "DISCOUNT_CARD_001")
let vehicle2 = Vehicle(plate: "2", type: VehicleType.moto, checkInTime: Date(), discountCard: nil)
let vehicle3 = Vehicle(plate: "3", type: VehicleType.miniBus, checkInTime: Date(), discountCard: nil)
let vehicle4 = Vehicle(plate: "4", type: VehicleType.bus, checkInTime: Date(), discountCard: "DISCOUNT_CARD_002")
let vehicle5 = Vehicle(plate: "4", type: VehicleType.car, checkInTime: Date(), discountCard: "DISCOUNT_CARD_003")
let vehicle6 = Vehicle(plate: "6", type: VehicleType.moto, checkInTime: Date(), discountCard: "DISCOUNT_CARD_004")
let vehicle7 = Vehicle(plate: "7", type: VehicleType.miniBus, checkInTime: Date(), discountCard: nil)
let vehicle8 = Vehicle(plate: "8", type: VehicleType.bus, checkInTime: Date(), discountCard: "DISCOUNT_CARD_005")
let vehicle9 = Vehicle(plate: "9", type: VehicleType.car, checkInTime: Date(), discountCard: nil)
let vehicle10 = Vehicle(plate: "10", type: VehicleType.moto, checkInTime: Date(), discountCard: nil)
let vehicle11 = Vehicle(plate: "11", type: VehicleType.miniBus, checkInTime: Date(), discountCard: nil)
let vehicle12 = Vehicle(plate: "12", type: VehicleType.bus, checkInTime: Date(), discountCard: "DISCOUNT_CARD_006")
let vehicle13 = Vehicle(plate: "13", type: VehicleType.car, checkInTime: Date(), discountCard: "DISCOUNT_CARD_007")
let vehicle14 = Vehicle(plate: "14", type: VehicleType.moto, checkInTime: Date(), discountCard: nil)
let vehicle15 = Vehicle(plate: "15", type: VehicleType.miniBus, checkInTime: Date(), discountCard: nil)
let vehicle16 = Vehicle(plate: "16", type: VehicleType.car, checkInTime: Date(), discountCard: "DISCOUNT_CARD_001")
let vehicle17 = Vehicle(plate: "17", type: VehicleType.car, checkInTime: Date(), discountCard: "DISCOUNT_CARD_001")
let vehicle18 = Vehicle(plate: "18", type: VehicleType.moto, checkInTime: Date(), discountCard: nil)
let vehicle19 = Vehicle(plate: "19", type: VehicleType.bus, checkInTime: Date(), discountCard: "teste")
let vehicle20 = Vehicle(plate: "20", type: VehicleType.moto, checkInTime: Date(), discountCard: nil)
let vehicle21 = Vehicle(plate: "21", type: VehicleType.moto, checkInTime: Date(), discountCard: nil)
let vehicle22 = Vehicle(plate: "22", type: VehicleType.moto, checkInTime: Date(), discountCard: nil)


var myVehicles = [vehicle1, vehicle2, vehicle3, vehicle4, vehicle5, vehicle6, vehicle7, vehicle8, vehicle9, vehicle10, vehicle11, vehicle12, vehicle13, vehicle14, vehicle15, vehicle16, vehicle17, vehicle18, vehicle19, vehicle20, vehicle21, vehicle22]


for myVehicle in myVehicles {
    alkeParking.checkInVehicle(myVehicle) { _ in }
}

alkeParking.checkOutVehicle(plate: "19") { fee in
    print("⚠️⚠️⚠️⚠️ FEE: \(fee)")
} onError: {}

alkeParking.checkOutVehicle(plate: "1") { fee in
    print("⚠️⚠️⚠️⚠️ FEE: \(fee)")
} onError: {}


alkeParking.showEarnings()

alkeParking.listVehicles()
