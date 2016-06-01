//
//  BackgroundCardView.swift
//  Beto
//
//  Created by Varun Patel on 6/1/16.
//  Copyright © 2016 Varun D Patel. All rights reserved.
//

import UIKit

class BackgroundCardView: UIView, CardViewDelegate {
    var cardDataModel: [String]!
    var allCardDataModel: [CardView]!
    
    let MAX_BUFFER_SIZE = 2
    let CARD_HEIGHT: CGFloat = 386
    let CARD_WIDTH: CGFloat = 290
    
    var fetchCardIndex: Int!
    var fetchedCards: [CardView]!
    var menuButton: UIButton!
    var messageButton: UIButton!
    var checkButton: UIButton!
    var xButton: UIButton!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        super.layoutSubviews()
        self.setupView()
        //TODO: Add Your Data Model Here:
        cardDataModel = ["Data Model 1", "Data Model 2", "Data Model 3"]
        allCardDataModel = []
        fetchedCards = []
        fetchCardIndex = 0
        self.loadCards()
    }
    
    func setupView() -> Void {
        self.backgroundColor = UIColor(red: 0.92, green: 0.93, blue: 0.95, alpha: 1)
        
        xButton = UIButton(frame: CGRectMake((self.frame.size.width - CARD_WIDTH)/2 + 35, self.frame.size.height/2 + CARD_HEIGHT/2 + 10, 59, 59))
        xButton.setImage(UIImage(named: "xButton"), forState: UIControlState.Normal)
        xButton.addTarget(self, action: #selector(BackgroundCardView.swipeLeft), forControlEvents: UIControlEvents.TouchUpInside)
        
        checkButton = UIButton(frame: CGRectMake(self.frame.size.width/2 + CARD_WIDTH/2 - 85, self.frame.size.height/2 + CARD_HEIGHT/2 + 10, 59, 59))
        checkButton.setImage(UIImage(named: "checkButton"), forState: UIControlState.Normal)
        checkButton.addTarget(self, action: #selector(BackgroundCardView.swipeRight), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.addSubview(xButton)
        self.addSubview(checkButton)
    }
    
    func createCardViewWithDataAtIndex(index: NSInteger) -> CardView {
        let cardView = CardView(frame: CGRectMake((self.frame.size.width - CARD_WIDTH)/2, (self.frame.size.height - CARD_HEIGHT)/2, CARD_WIDTH, CARD_HEIGHT))
        cardView.information.text = cardDataModel[index]
        cardView.delegate = self
        return cardView
    }
    
    func loadCards() -> Void {
        if cardDataModel.count > 0 {
            let numfetchedCardsCap = cardDataModel.count > MAX_BUFFER_SIZE ? MAX_BUFFER_SIZE : cardDataModel.count
            for i in 0 ..< cardDataModel.count {
                let newCard: CardView = self.createCardViewWithDataAtIndex(i)
                allCardDataModel.append(newCard)
                if i < numfetchedCardsCap {
                    fetchedCards.append(newCard)
                }
            }
            
            for i in 0 ..< fetchedCards.count {
                if i > 0 {
                    self.insertSubview(fetchedCards[i], belowSubview: fetchedCards[i - 1])
                } else {
                    self.addSubview(fetchedCards[i])
                }
                fetchCardIndex = fetchCardIndex + 1
            }
        }
    }
    
    func cardSwipedLeft(card: UIView) -> Void {
        fetchedCards.removeAtIndex(0)
        
        if fetchCardIndex < allCardDataModel.count {
            fetchedCards.append(allCardDataModel[fetchCardIndex])
            fetchCardIndex = fetchCardIndex + 1
            self.insertSubview(fetchedCards[MAX_BUFFER_SIZE - 1], belowSubview: fetchedCards[MAX_BUFFER_SIZE - 2])
        }
    }
    
    func cardSwipedRight(card: UIView) -> Void {
        fetchedCards.removeAtIndex(0)
        
        if fetchCardIndex < allCardDataModel.count {
            fetchedCards.append(allCardDataModel[fetchCardIndex])
            fetchCardIndex = fetchCardIndex + 1
            self.insertSubview(fetchedCards[MAX_BUFFER_SIZE - 1], belowSubview: fetchedCards[MAX_BUFFER_SIZE - 2])
        }
    }
    
    func swipeRight() -> Void {
        if fetchedCards.count <= 0 {
            return
        }
        let dragView: CardView = fetchedCards[0]
        dragView.overlayView.setMode(CGCoverOverlayViewState
            .GGOverlayViewModeRight)
        UIView.animateWithDuration(0.2, animations: {
            () -> Void in
            dragView.overlayView.alpha = 1
        })
        dragView.rightClickAction()
    }
    
    func swipeLeft() -> Void {
        if fetchedCards.count <= 0 {
            return
        }
        let dragView: CardView = fetchedCards[0]
        dragView.overlayView.setMode(CGCoverOverlayViewState.GGOverlayViewModeLeft)
        UIView.animateWithDuration(0.2, animations: {
            () -> Void in
            dragView.overlayView.alpha = 1
        })
        dragView.leftClickAction()
    }
}