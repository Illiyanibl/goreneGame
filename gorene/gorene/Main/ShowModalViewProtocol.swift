//
//  ShowModalViewProtocol.swift
//  gorene
//
//  Created by Illya Blinov on 5.10.25.
//
protocol ShowModalViewProtocol: AnyObject {
    var delegateClose: ShowModalViewDelegate? { get set }
}

protocol ShowModalViewDelegate: AnyObject {
    func modalViewDidClose(_ modalView: ShowModalViewProtocol)
}

