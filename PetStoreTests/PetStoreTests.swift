//
//  PetStoreTests.swift
//  PetStoreTests
//
//  Created by Tushar Kalra on 30/11/22.
//

import XCTest
@testable import PetStore

final class PetStoreTests: XCTestCase {

    var viewModel: PetViewModel!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewModel = PetViewModel()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModel = nil
    }
    
    func testSuccessfulModelNotNil() throws {
        XCTAssertNotNil(viewModel)
    }
    
    func testSuccessfulFilesAvailable() throws {
        let configFileURL = Bundle.main.url(forResource: "config", withExtension: "json")
        XCTAssertNotNil(configFileURL, "Config file not available")
        
        let petsFileURl = Bundle.main.url(forResource: "pets_list", withExtension: "json")
        XCTAssertNotNil(petsFileURl, "Pets list file not available")
    }
    
    func testSuccessfulConfigAvailable() throws {
        
        let configFileURL = Bundle.main.url(forResource: "config", withExtension: "json")
        XCTAssertNotNil(configFileURL, "Config file not available")
        
        let data = try? Data(contentsOf: configFileURL!)
        XCTAssertNotNil(data, "Conversion from 'config' failed")
        
        let config = try? JSONSerialization.jsonObject(with: data!) as? [String : AnyObject]
        XCTAssertNotNil(config)
        
        let settings = config!["settings"] as? [String : AnyObject]
        XCTAssertNotNil(settings)
    }
    
    func testSuccessfulPetListAvailable() throws {
        
        let petsFileURl = Bundle.main.url(forResource: "pets_list", withExtension: "json")
        XCTAssertNotNil(petsFileURl, "Pets list file not available")
        
        let data = try? Data(contentsOf: petsFileURl!)
        XCTAssertNotNil(data, "Conversion from 'pets_list' failed")
        
        let decoder = JSONDecoder()
        
        let pets = try? decoder.decode(Pets.self, from: data!)
        XCTAssertNotNil(pets, "Pets is nil")
    }
    
    func testSuccesfulTitleCorrectlyFormatted() throws {
        
        let input = "Guinea Pig"
        let expectedOutput = "Guinea_pig"
        
        let words = input.components(separatedBy: " ")
        var title = words.first!
        
        if words.count > 1 {
            for i in 1..<words.count {
                title += "_" + words[i].lowercased()
            }
        }
        XCTAssertEqual(expectedOutput, title)
    }
}
