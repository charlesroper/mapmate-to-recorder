SELECT
  Records.[_guk]
, Records.[_guk] AS MapMate_guk
, [Taxa\Default].Taxon
, [Sites\Default].Name      AS Location_name
, [Sites\Default].OSGridRef AS Gridref
,
  IIF
  (
    [Sites\Default].[ViceCounty]>200,'H' & [Sites\Default].[ViceCounty]-200,[Sites\Default].[ViceCounty]
  ) AS Vice_county
, (
  IIF
  (
    Records.Quantity=-1, 'd',
    IIF
    (
      Records.Quantity=-2, 'a',
      IIF
      (
        Records.Quantity=-3, 'f',
        IIF
        (
          Records.Quantity=-4, 'o',
          IIF
          (
            Records.Quantity=-5, 'r',
            IIF
            (
              Records.Quantity=-6, 'vr',
              IIF
              (
                Records.Quantity=-7, 'NotPresent',
                IIF
                (
                  Records.Quantity=0, 'Present ', Records.Quantity
                )
              )
            )
          )
        )
      )
    )
  )
  ) & (
  IIF
  (
    [Records]![*Stage]='0', 'None',
    IIF
    (
      [Records]![*Stage]='l', 'FirstWinter',
      IIF
      (
        [Records]![*Stage]='m', 'SecondWinter',
        IIF
        (
          [Records]![*Stage]='n', 'ThirdWinter',
          IIF
          (
            [Records]![*Stage]='o', 'FourthWinter',
            IIF
            (
              [Records]![*Stage]='p', 'FirstSummer',
              IIF
              (
                [Records]![*Stage]='q', 'SecondSummer',
                IIF
                (
                  [Records]![*Stage]='r', 'ThirdSummer',
                  IIF
                  (
                    [Records]![*Stage]='s', 'FourthSummer', [TaxonStage].[Stage]
                  )
                )
              )
            )
          )
        )
      )
    )
  )
  ) & (
  IIF
  (
    [Records]![*Sex]='u', '',
    IIF
    (
      [Records]![*Sex]='g', 'MixedSexGroup', [TaxonSex].[Sex]
    )
  )
  ) AS Abundance
,
  IIF
  (
    [Records].[Date] = [Records].[DateTo], Format([Records].[Date],'dd/mm/yyyy'), (Format([Records].[Date],'dd/mm/yyyy') & " - " & Format([Records].[DateTo],'dd/mm/yyyy'))
  )                AS DateRange
, Recorders.Name   AS Recorder
, Recorders_1.Name AS Determiner
, Methods.Method
, Records.Comment
FROM
  ((((((Records
  INNER JOIN [Taxa\Default]
  ON
    Records.[*Taxon] = [Taxa\Default].[_guk])
  INNER JOIN [Sites\Default]
  ON
    Records.[*Site] = [Sites\Default].[_guk])
  INNER JOIN Methods
  ON
    Records.[*Method] = Methods.[_guk])
  INNER JOIN Recorders
  ON
    Records.[*Recorder] = Recorders.[_guk])
  INNER JOIN TaxonStage
  ON
    Records.[*Stage] = TaxonStage.[_guk])
  INNER JOIN TaxonSex
  ON
    Records.[*Sex] = TaxonSex.[_guk])
  INNER JOIN Recorders AS Recorders_1
  ON
    Records.[*Identifier] = Recorders_1.[_guk]
WHERE
  (
    (
      (
        [Sites\Default].OSGridRef
      )
      IS NOT NULL
    )
  )
AND
  (
    Records.[_gen] <> 1
  );