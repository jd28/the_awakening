void main(){

    // white
    if(GetTag(OBJECT_SELF) == "bishop_w"){ //bishop
        SetLocalInt(OBJECT_SELF, "nPiece", 4);
    }
    else if(GetTag(OBJECT_SELF) == "king_w"){ // King
        SetLocalInt(OBJECT_SELF, "nPiece", 6);
        SetLocalInt(OBJECT_SELF, "bOriginalPos", 1);
    }
    else if(GetTag(OBJECT_SELF) == "knight_w"){ // Knight
        SetLocalInt(OBJECT_SELF, "nPiece", 3);
    }
    else if(GetTag(OBJECT_SELF) == "pawn_w"){ // Pawn
        SetLocalInt(OBJECT_SELF, "nPiece", 1);
        SetLocalInt(OBJECT_SELF, "bOriginalPos", TRUE);
        SetLocalInt(OBJECT_SELF, "promote", 0);
    }
    else if(GetTag(OBJECT_SELF) == "queen_w"){ // Queen
        SetLocalInt(OBJECT_SELF, "nPiece", 5);
    }
    else if(GetTag(OBJECT_SELF) == "rook_w"){ // Rook
        SetLocalInt(OBJECT_SELF, "nPiece", 2);
        SetLocalInt(OBJECT_SELF, "bOriginalPos", 1);
    }
    // black
    else if(GetTag(OBJECT_SELF) == "bishop_b"){ //bishop
        SetLocalInt(OBJECT_SELF, "nPiece", -4);
    }
    else if(GetTag(OBJECT_SELF) == "king_b"){ // King
        SetLocalInt(OBJECT_SELF, "nPiece", -6);
        SetLocalInt(OBJECT_SELF, "bOriginalPos", 1);
    }
    else if(GetTag(OBJECT_SELF) == "knight_b"){ // Knight
        SetLocalInt(OBJECT_SELF, "nPiece", -3);
    }
    else if(GetTag(OBJECT_SELF) == "pawn_b"){ // Pawn
        SetLocalInt(OBJECT_SELF, "nPiece", -1);
        SetLocalInt(OBJECT_SELF, "bOriginalPos", TRUE);
        SetLocalInt(OBJECT_SELF, "promote", 0);
    }
    else if(GetTag(OBJECT_SELF) == "queen_b"){ // Queen
        SetLocalInt(OBJECT_SELF, "nPiece", -5);
    }
    else if(GetTag(OBJECT_SELF) == "rook_b"){ // Rook
        SetLocalInt(OBJECT_SELF, "nPiece", -2);
        SetLocalInt(OBJECT_SELF, "bOriginalPos", 1);
    }
}
