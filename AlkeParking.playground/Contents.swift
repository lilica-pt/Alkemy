//
// Authors: Daniel e Lili
//

import Foundation

// MARK: 2
enum VehicleType {
    case car, moto, miniBus, bus
}

// MARK: 1
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
    
    // MARK: 5
    mutating func checkInVehicle(_ vehicle: Vehicle, onFinish: (Bool) -> Void) {
        guard vehicles.count <= full else {
            print("Sorry, the check-in failed due to vacancy")
            return onFinish(false)
        }
        for car in vehicles {
            if car.plate == vehicle.plate {
                print("Sorry, the check-in failed, \(vehicle.plate) already in")
                return onFinish(false)
            }
        }
        vehicles.insert(vehicle)
        print("Welcome to AlkeParking!")
        return onFinish(true)
    }
    
    // MARK: 8
    mutating func calculateFee(_ type: VehicleType, _ parkedTime: Int?, hasDiscountCard: String?) -> Int {
        var fee: Int
        switch type {
        case .car:
            fee = 20
        case .moto:
            fee = 15
        case .miniBus:
            fee = 25
        case .bus:
            fee = 30
        }
        
        guard let parkedTime = parkedTime else { return 0 }
        
        if parkedTime > 120 {
            let coupleHours = parkedTime - 120
            let makeRound = coupleHours / 15
            if coupleHours % 15 != 0 {
                fee = fee + ((makeRound + 1) * 5)
            } else {
                fee = fee + (makeRound * 5)
            }
        }
        
        // MARK: 9
        guard let hasDiscountCard = hasDiscountCard else { return fee }
        let discountFee = Int(Double(fee) * 0.85)
        return discountFee
    }
    
    // MARK: 7
    mutating func checkOutVehicle(plate: String, onSucess: (Int) -> Void, onError: () ->  Void){
        for vehicle in vehicles {
            var variableVehicle = vehicle
            if variableVehicle.plate == plate {
                let fee = calculateFee(variableVehicle.type, variableVehicle.parkedTime, hasDiscountCard: variableVehicle.discountCard)
                // MARK: 10
                onSucess(fee)
                vehicles.remove(vehicle)
                aviability.0 += 1
                aviability.1 += fee
            } else {
                onError()
            }
        }
    }
    
    // MARK: 11
    func showEarnings(){
        print("\(aviability.0) vehicles have checked out and our earnings are \(aviability.1)")
    }
    
    // MARK: 12
    func listVehicles(){
        for vehicle in vehicles {
            print("plate: \(vehicle.plate)")
        }
    }
}

struct Vehicle: Hashable, Parkable {
    var plate: String
    // MARK: 2
    let type: VehicleType
    var checkInTime: Date
    var discountCard: String?
    
    // MARK: 3
    lazy var parkedTime: Int? = {
        let mins = Calendar.current.dateComponents([.minute], from: self.checkInTime, to: Date()).minute ?? 0
        return mins
    }()
    
    func hash(into hasher: inout Hasher){
        hasher.combine(plate)
    }
    
    static func ==(lhs: Vehicle, rhs: Vehicle) -> Bool {
        return lhs.plate == rhs.plate
    }
}

// MARK: 4
var alkeParking = Parking()

// MARK: 6
let vehicle1 = Vehicle(plate: "AA111AA", type:VehicleType.car, checkInTime: Date(), discountCard:"DISCOUNT_CARD_001")
let vehicle2 = Vehicle(plate: "B222BBB", type:VehicleType.moto, checkInTime: Date(), discountCard: nil)
let vehicle3 = Vehicle(plate: "CC333CC", type:VehicleType.miniBus, checkInTime: Date(), discountCard:nil)
let vehicle4 = Vehicle(plate: "DD444DD", type:VehicleType.bus, checkInTime: Date(), discountCard:"DISCOUNT_CARD_002")
let vehicle5 = Vehicle(plate: "AA111BB", type:VehicleType.car, checkInTime: Date(), discountCard:"DISCOUNT_CARD_003")
let vehicle6 = Vehicle(plate: "B222CCC", type:VehicleType.moto, checkInTime: Date(), discountCard:"DISCOUNT_CARD_004")
let vehicle7 = Vehicle(plate: "CC333CC", type:VehicleType.miniBus, checkInTime: Date(), discountCard:nil)
let vehicle8 = Vehicle(plate: "DD444EE", type:VehicleType.bus, checkInTime: Date(), discountCard:"DISCOUNT_CARD_005")
let vehicle9 = Vehicle(plate: "AA111CC", type:VehicleType.car, checkInTime: Date(), discountCard: nil)
let vehicle10 = Vehicle(plate: "B222DDD", type:VehicleType.moto, checkInTime: Date(), discountCard: nil)
let vehicle11 = Vehicle(plate: "CC333EE", type:VehicleType.miniBus, checkInTime: Date(), discountCard:nil)
let vehicle12 = Vehicle(plate: "DD444GG", type:VehicleType.bus, checkInTime: Date(), discountCard:"DISCOUNT_CARD_006")
let vehicle13 = Vehicle(plate: "AA111DD", type:VehicleType.car, checkInTime: Date(), discountCard:"DISCOUNT_CARD_007")
let vehicle14 = Vehicle(plate: "B222EEE", type:VehicleType.moto, checkInTime: Date(), discountCard: nil)
let vehicle15 = Vehicle(plate: "CC333FF", type:VehicleType.miniBus, checkInTime: Date(), discountCard:nil)
let vehicle16 = Vehicle(plate: "XA111AA", type: VehicleType.car, checkInTime: Date(), discountCard: "DISCOUNT_CARD_001")
let vehicle17 = Vehicle(plate: "AA11XAA", type: VehicleType.car, checkInTime: Date(), discountCard: "DISCOUNT_CARD_001")
let vehicle18 = Vehicle(plate: "B222BBB", type: VehicleType.moto, checkInTime: Date(), discountCard: nil)
let vehicle19 = Vehicle(plate: "B222BCB", type: VehicleType.moto, checkInTime: Date(), discountCard: nil)
let vehicle20 = Vehicle(plate: "B222DBB", type: VehicleType.moto, checkInTime: Date(), discountCard: nil)
let vehicle21 = Vehicle(plate: "B222XBB", type: VehicleType.moto, checkInTime: Date(), discountCard: nil)
let vehicle22 = Vehicle(plate: "B222XBX", type: VehicleType.moto, checkInTime: Date(), discountCard: nil)


var myVehicles = [vehicle1, vehicle2, vehicle3, vehicle4, vehicle5, vehicle6, vehicle7, vehicle8, vehicle9, vehicle10, vehicle11, vehicle12, vehicle13, vehicle14, vehicle15, vehicle16, vehicle17, vehicle18, vehicle19, vehicle20, vehicle21, vehicle22]

for myVehicle in myVehicles {
    alkeParking.checkInVehicle(myVehicle) { _ in }
}

alkeParking.checkOutVehicle(plate: "B222EEE") { fee in
    print("⚠️⚠️⚠️⚠️ FEE: \(fee)")
} onError: {}

alkeParking.checkOutVehicle(plate: "CC333FF") { fee in
    print("⚠️⚠️⚠️⚠️ FEE: \(fee)")
} onError: {}

alkeParking.showEarnings()

alkeParking.listVehicles()
