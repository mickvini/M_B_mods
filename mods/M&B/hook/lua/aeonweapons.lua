ADFTractorClaw = Class(DefaultBeamWeapon) {
    BeamType = TractorClawCollisionBeam,
    FxMuzzleFlash = {},
   
    PlayFxBeamStart = function(self, muzzle)
        local target = self:GetCurrentTarget()
        if not target or
            EntityCategoryContains(categories.STRUCTURE, target) or
            EntityCategoryContains(categories.COMMAND, target) or
            EntityCategoryContains(categories.EXPERIMENTAL, target) or
            EntityCategoryContains(categories.NAVAL, target) or
            EntityCategoryContains(categories.SUBCOMMANDER, target) or
            EntityCategoryContains(categories.NEEDMOBILEBUILD, target) or
            not EntityCategoryContains(categories.ALLUNITS, target) then
            return
        end

        #Can't pass recon blips down
        target = self:GetRealTarget(target)
        
        if self:IsTargetAlreadyUsed(target) then 
            return 
        end
        
        ###Create vacuum suck up from ground effects on the unit targetted.
        for k, v in EffectTemplate.ACollossusTractorBeamVacuum01 do
            CreateEmitterAtEntity( target, target:GetArmy(),v ):ScaleEmitter(0.25*target:GetFootPrintSize()/0.5)
        end
        
        DefaultBeamWeapon.PlayFxBeamStart(self, muzzle)

        self.TT1 = self:ForkThread(self.TractorThread, target)
        self:ForkThread(self.TractorWatchThread, target)
    end,
    
    # override this function in the unit to check if another weapon already has this
    # unit as a target.  Target argument should not be a recon blip
    IsTargetAlreadyUsed = function(self, target)
        local weap
        for i = 1, self.unit:GetWeaponCount() do
            weap = self.unit:GetWeapon(i)
            if (weap != self) then
                if self:GetRealTarget(weap:GetCurrentTarget()) == target then
                    #LOG("Target already used by ", repr(weap:GetBlueprint().Label))
                    return true
                end
            end
        end
        return false
    end,

    #recon blip check
    GetRealTarget = function(self, target)
        if target and not IsUnit(target) then
            local unitTarget = target:GetSource()
            local unitPos = unitTarget:GetPosition()
            local reconPos = target:GetPosition()
            local dist = VDist2(unitPos[1], unitPos[3], reconPos[1], reconPos[3])
            if dist < 10 then
                return unitTarget
            end
        end
        return target      
    end,

    OnLostTarget = function(self)
        self:AimManipulatorSetEnabled(true)
        DefaultBeamWeapon.OnLostTarget(self)
        ###enabled= false
        ###self.unit:SetEnabled(false)
        DefaultBeamWeapon.PlayFxBeamEnd(self,self.Beams[1].Beam)
    end,

    TractorThread = function(self, target)
        self.unit.Trash:Add(target)
        local beam = self.Beams[1].Beam
        if not beam then return end


        local muzzle = self:GetBlueprint().MuzzleSpecial
        if not muzzle then return end

        target:SetDoNotTarget(true)
        local pos0 = beam:GetPosition(0)
        local pos1 = beam:GetPosition(1)
        local dist = VDist3(pos0, pos1)

        self.Slider = CreateSlider(self.unit, muzzle, 0, 0, dist, -1, true)

        WaitTicks(1)
        WaitFor(self.Slider)

        # just in case attach fails...
        target:SetDoNotTarget(false)
        target:AttachBoneTo(-1, self.unit, muzzle)
        target:SetDoNotTarget(true)
        
        self.AimControl:SetResetPoseTime(10)

        self.Slider:SetSpeed(15)
        self.Slider:SetGoal(0,0,0)
        
        WaitTicks(1)
        WaitFor(self.Slider)

        if not target:IsDead() then
            target.DestructionExplosionWaitDelayMin = 0
            target.DestructionExplosionWaitDelayMax = 0
            
            ##:ScaleEmitter(util.GetRandomFloat(ScaleMin, ScaleMax))
            ###CreateAttachedEmitter( self, bone, self.GetArmy(), blueprint ) 
            for kEffect, vEffect in EffectTemplate.ACollossusTractorBeamCrush01 do
                CreateEmitterAtBone( self.unit, muzzle , self.unit:GetArmy(), vEffect )###:ScaleEmitter(0.35)
            end
            
            target:Kill(self.unit, 'Damage', 100)
        end
        
        self.AimControl:SetResetPoseTime(2)
    end,

    TractorWatchThread = function(self, target)
        while not target:IsDead() do
            WaitTicks(1)
        end
        KillThread(self.TT1)
        self.TT1 = nil
        if self.Slider then
            self.Slider:Destroy()
            self.Slider = nil
        end
        self.unit:DetachAll(self:GetBlueprint().MuzzleSpecial or 0)
        self:ResetTarget()
        self.AimControl:SetResetPoseTime(2)
    end,
}

