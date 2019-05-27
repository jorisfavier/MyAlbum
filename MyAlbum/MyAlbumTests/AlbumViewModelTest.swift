//
//  MyAlbumTests.swift
//  MyAlbumTests
//
//  Created by joris favier on 24/05/2019.
//  Copyright © 2019 jorisfavier. All rights reserved.
//

import XCTest
import Nimble
import RxBlocking
import RxSwift

@testable import MyAlbum

let fakeAlbum1 = AlbumDTO(userId: 1, id: 1, title: "album 1")
let fakeAlbum2 = AlbumDTO(userId: 1, id: 2, title: "album 2")
let fakePhoto1 = PhotoDTO(albumId: 1, id: 1, title: "photo 1", url: "http://test.com", thumbnailUrl: "http://thumbnail.com/album1")
let fakePhoto2 = PhotoDTO(albumId: 2, id: 1, title: "photo 1", url: "http://test.com", thumbnailUrl: "http://thumbnail.com/album2")


class AlbumViewModelTest: XCTestCase {
    
    func test_reloadEmited_albumShouldBeFetched() {
        //given
        let mockService = MockAlbumService(fakeAlbums: [fakeAlbum1], fakePhotos: [fakePhoto1])
        
        //when
        let viewmodel = AlbumViewModel(albumService: mockService)
        viewmodel.reload.onNext(())
        
        //then
        let result = try! viewmodel.albums.toBlocking(timeout: 1).first()
        expect(result).to(haveCount(1))
        
    }
    
    func test_albumFetched_albumShouldHaveThumbnail() {
        //given
        let mockService = MockAlbumService(fakeAlbums: [fakeAlbum1,fakeAlbum2], fakePhotos: [fakePhoto1,fakePhoto2])
        let expectedResult = Album(album: fakeAlbum1)
        expectedResult.photos = [Photo(photoDTO: fakePhoto1)]
        
        //when
        let viewmodel = AlbumViewModel(albumService: mockService)
        viewmodel.reload.onNext(())
        
        //then
        let result = try! viewmodel.albums.toBlocking(timeout: 1).first()
        expect(result).to(haveCount(2))
        expect(result).to(contain([expectedResult]))
        
    }
    
    func test_onNetworkErrorWithAlbum_errorShouldBeRaised() {
        //given
        let mockService = MockAlbumService(fakeAlbums: nil, fakePhotos: [fakePhoto1,fakePhoto2])
        
        //when
        let viewmodel = AlbumViewModel(albumService: mockService)
        //add delay in order to catch the error
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            viewmodel.reload.onNext(())
        }
        
        //then
        let result = try! viewmodel.error
            .toBlocking(timeout: 3).first()
        expect(result).toNot(beNil())
    }
    
    func test_onNetworkErrorWithPhoto_errorShouldBeRaised() {
        //given
        let mockService = MockAlbumService(fakeAlbums: [fakeAlbum1,fakeAlbum2], fakePhotos: nil)
        
        //when
        let viewmodel = AlbumViewModel(albumService: mockService)
        //add delay in order to catch the error
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            viewmodel.reload.onNext(())
        }
        
        //then
        let result = try! viewmodel.error
            .toBlocking(timeout: 3).first()
        expect(result).toNot(beNil())
    }

}
